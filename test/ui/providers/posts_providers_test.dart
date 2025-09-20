import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_list/app/di/providers.dart';
import 'package:posts_list/domain/entities/post_entity.dart';
import 'package:posts_list/domain/repositories/posts_repo.dart';
import 'package:posts_list/ui/providers/posts_providers.dart';

class FakePostsRepo implements PostsRepo {
  FakePostsRepo(this._list);
  List<Post> _list;

  @override
  Future<List<Post>> fetchAll() async => _list;

  @override
  Future<Post> getPost(int id) async => _list.firstWhere((p) => p.id == id);
}

Post p(int id, String t) => Post(
  id: id,
  title: t,
  shortDescription: 'Short $id',
  fullDescription: 'Full $id',
);

void main() {
  test('should return posts', () async {
    final container = ProviderContainer(
      overrides: [
        postsRepoProvider.overrideWithValue(
          FakePostsRepo([p(1, 'One'), p(2, 'Two')]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(postsListProvider.future);
    expect(result.map((e) => e.id), [1, 2]);
  });

  test('should return all posts when query is empty', () async {
    final container = ProviderContainer(
      overrides: [
        postsRepoProvider.overrideWithValue(
          FakePostsRepo([p(1, 'Alpha'), p(2, 'Beta')]),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(queryProvider.notifier).state = '';
    final result = await container.read(postsListProvider.future);
    expect(result.length, 2);
  });

  test(
    'should filter posts by title when query changes (case-insensitive)',
    () async {
      final container = ProviderContainer(
        overrides: [
          postsRepoProvider.overrideWithValue(
            FakePostsRepo([p(1, 'Alpha'), p(2, 'Beta'), p(3, 'Alphabet')]),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(queryProvider.notifier).state = 'alp';
      final filtered = await container.read(postsListProvider.future);
      expect(filtered.map((e) => e.id), [1, 3]);
    },
  );

  test('should refresh posts when provider is refreshed', () async {
    final repo = FakePostsRepo([p(1, 'One')]);
    final container = ProviderContainer(
      overrides: [postsRepoProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    expect((await container.read(postsListProvider.future)).length, 1);

    repo._list = [p(1, 'One'), p(2, 'Two')];
    final refreshed = await container.refresh(postsListProvider.future);
    expect(refreshed.length, 2);
  });

  test('should return post by id in detail provider', () async {
    final container = ProviderContainer(
      overrides: [
        postsRepoProvider.overrideWithValue(FakePostsRepo([p(7, 'Seven')])),
      ],
    );
    addTearDown(container.dispose);

    final post = await container.read(postDetailProvider(7).future);
    expect(post.title, 'Seven');
  });
}
