import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/app/theme/tokens.dart';
import 'package:posts_list/ui/providers/posts_providers.dart';
import 'package:posts_list/ui/views/post_details.dart';
import 'package:posts_list/ui/widgets/app_scaffold.dart';
import 'package:posts_list/ui/widgets/post_card.dart';
import 'package:posts_list/ui/widgets/search_field.dart';

class PostsListView extends ConsumerWidget {
  const PostsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsListProvider);

    return AppScaffold(
      title: 'Feed',
      child: Column(
        children: [
          const SizedBox(height: Tokens.pad12),
          const SearchField(),
          Expanded(
            child: postsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Failed to load: $e'),
                    const SizedBox(height: Tokens.pad24),
                    FilledButton(
                      onPressed: () => ref.refresh(postsListProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (posts) => posts.isEmpty
                  ? const Center(child: Text('No posts'))
                  : RefreshIndicator(
                      onRefresh: () async => ref.refresh(postsListProvider),
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (_, i) {
                          final p = posts[i];
                          return Padding(
                            padding: const EdgeInsets.only(top: Tokens.pad24),
                            child: PostCard(
                              post: p,
                              onTap: () => Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) =>
                                      PostDetailsView(id: p.id),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
