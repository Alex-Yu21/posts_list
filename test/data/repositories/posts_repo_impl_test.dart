import 'package:flutter_test/flutter_test.dart';
import 'package:posts_list/data/data_sources/posts_remote.dart';
import 'package:posts_list/data/repositories/posts_repo_impl.dart';
import 'package:posts_list/domain/entities/post_entity.dart';
import 'package:posts_list/domain/repositories/posts_repo.dart';

class _FakeRemote implements PostsRemote {
  List<Post> store;
  int fetchAllCalls = 0;
  int fetchByIdCalls = 0;

  bool throwOnFetchAll = false;
  bool throwOnFetchById = false;

  _FakeRemote(this.store);

  @override
  Future<List<Post>> fetchAll() async {
    fetchAllCalls++;
    if (throwOnFetchAll) throw Exception('fetchAll failed');
    return store;
  }

  @override
  Future<Post> fetchById(int id) async {
    fetchByIdCalls++;
    if (throwOnFetchById) throw Exception('fetchById failed');
    return store.firstWhere((p) => p.id == id);
  }
}

void main() {
  group('PostsRepoImpl', () {
    late _FakeRemote remote;
    late PostsRepo repo;

    Post p(int id, String title, String body) => Post(
      id: id,
      title: title,
      shortDescription: body,
      fullDescription: body,
    );

    setUp(() {
      remote = _FakeRemote([p(1, 'Hello', 'Body 1'), p(2, 'World', 'Body 2')]);
      repo = PostsRepoImpl(remote);
    });

    test('should fetch all posts once and cache the result', () async {
      final first = await repo.fetchAll();
      final second = await repo.fetchAll();

      expect(first.length, 2);
      expect(second.length, 2);
      expect(identical(first, second), isTrue, reason: 'returns cached list');
      expect(remote.fetchAllCalls, 1, reason: 'remote called only once');
    });

    test(
      'should get post from id cache after fetchAll without calling remote.fetchById',
      () async {
        await repo.fetchAll();

        final post = await repo.getPost(2);
        expect(post.id, 2);
        expect(remote.fetchByIdCalls, 0, reason: 'served from cache');
      },
    );

    test(
      'should fetch single post remotely when not cached and not populate list cache',
      () async {
        final post = await repo.getPost(1);
        expect(post.id, 1);
        expect(remote.fetchByIdCalls, 1);

        await repo.fetchAll();
        expect(remote.fetchAllCalls, 1);
      },
    );

    test('should refresh list cache and rebuild id index', () async {
      final initial = await repo.fetchAll();
      expect(initial.map((p) => p.id), [1, 2]);

      remote.store = [
        p(1, 'Hello (updated)', 'Body 1*'),
        p(3, 'New', 'Body 3'),
      ];
      await repo.refresh();

      final after = await repo.fetchAll();
      expect(after.map((p) => p.id), [1, 3]);

      final p1 = await repo.getPost(1);
      expect(p1.title, 'Hello (updated)');
    });

    test(
      'should propagate exception from remote.fetchAll in fetchAll',
      () async {
        remote.throwOnFetchAll = true;
        await expectLater(repo.fetchAll(), throwsA(isA<Exception>()));
      },
    );

    test(
      'should propagate exception from remote.fetchAll in refresh',
      () async {
        remote.throwOnFetchAll = true;
        await expectLater(repo.refresh(), throwsA(isA<Exception>()));
      },
    );

    test(
      'should propagate exception from remote.fetchById in getPost',
      () async {
        remote.throwOnFetchById = true;
        await expectLater(repo.getPost(1), throwsA(isA<Exception>()));
      },
    );
  });
}
