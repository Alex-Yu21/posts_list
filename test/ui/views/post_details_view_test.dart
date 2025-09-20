import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_list/app/di/providers.dart';
import 'package:posts_list/domain/entities/post_entity.dart';
import 'package:posts_list/domain/repositories/posts_repo.dart';
import 'package:posts_list/ui/views/post_details.dart';

class FakePostsRepo implements PostsRepo {
  FakePostsRepo(this.data, {this.throwOnGetById = false});
  final Map<int, Post> data;
  bool throwOnGetById;

  @override
  Future<Post> getPost(int id) async {
    if (throwOnGetById) throw Exception('boom');
    return data[id]!;
  }

  @override
  Future<List<Post>> fetchAll() async => data.values.toList();
}

Post p(int id, String t) => Post(
  id: id,
  title: t,
  shortDescription: 'Short $id',
  fullDescription: 'Full $id',
);

void main() {
  testWidgets('should show loading then content', (tester) async {
    final repo = FakePostsRepo({1: p(1, 'One')});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: PostDetailsView(id: 1)),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Post #1'), findsOneWidget);
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Full 1'), findsOneWidget);
  });

  testWidgets('should show error and retry reloads', (tester) async {
    final failing = FakePostsRepo({1: p(1, 'One')}, throwOnGetById: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(failing)],
        child: const MaterialApp(home: PostDetailsView(id: 1)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);

    final success = FakePostsRepo({1: p(1, 'One')});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(success)],
        child: const MaterialApp(home: PostDetailsView(id: 1)),
      ),
    );

    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('One'), findsOneWidget);
    expect(find.text('Full 1'), findsOneWidget);
  });

  testWidgets('should load post by given id', (tester) async {
    final repo = FakePostsRepo({1: p(1, 'One'), 2: p(2, 'Two')});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [postsRepoProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: PostDetailsView(id: 2)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Post #2'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Full 2'), findsOneWidget);
  });
}
