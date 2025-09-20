import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_list/app/di/providers.dart';
import 'package:posts_list/domain/entities/post_entity.dart';
import 'package:posts_list/domain/repositories/posts_repo.dart';
import 'package:posts_list/ui/views/posts_list_view.dart';

class FakePostsRepo implements PostsRepo {
  List<Post> data;
  bool throwOnGetAll;
  FakePostsRepo(this.data, {this.throwOnGetAll = false});

  @override
  Future<List<Post>> fetchAll() async {
    if (throwOnGetAll) throw Exception('boom');
    return data;
  }

  @override
  Future<Post> getPost(int id) async => data.firstWhere((p) => p.id == id);
}

Post p(int id, String t) => Post(
  id: id,
  title: t,
  shortDescription: 'Short $id',
  fullDescription: 'Full $id',
);

void main() {
  testWidgets('should show loading then data', (tester) async {
    final repo = FakePostsRepo([p(1, 'One'), p(2, 'Two')]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: PostsListView()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
  });

  testWidgets('should show error and retry reloads', (tester) async {
    final failing = FakePostsRepo([], throwOnGetAll: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(failing)],
        child: const MaterialApp(home: PostsListView()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Failed to load'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    final success = FakePostsRepo([p(1, 'A')]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(success)],
        child: const MaterialApp(home: PostsListView()),
      ),
    );
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('should filter list when typing query', (tester) async {
    final repo = FakePostsRepo([p(1, 'Alpha'), p(2, 'Beta'), p(3, 'Alphabet')]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: PostsListView()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'alp');

    await tester.pump();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Alphabet'), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('should refresh on pull-to-refresh', (tester) async {
    final repo = FakePostsRepo([p(1, 'One')]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: PostsListView()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('One'), findsOneWidget);

    repo.data = [p(1, 'One'), p(2, 'Two')];

    final listFinder = find.byType(ListView);
    await tester.drag(listFinder, const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Two'), findsOneWidget);
  });

  testWidgets('should navigate to detail on card tap', (tester) async {
    final repo = FakePostsRepo([p(1, 'One')]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: PostsListView()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('One'));
    await tester.pumpAndSettle();

    expect(find.text('Post #1'), findsOneWidget);
    expect(find.text('Full 1'), findsOneWidget);
  });
}
