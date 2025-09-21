import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/ui/providers/posts_providers.dart';
import 'package:posts_list/ui/views/post_details.dart';
import 'package:posts_list/ui/widgets/app_scaffold.dart';
import 'package:posts_list/ui/widgets/post_card.dart';
import 'package:posts_list/ui/widgets/search_field.dart';

class PostsListView extends ConsumerWidget {
  const PostsListView({super.key});

  static const _kPad24 = 24.0;
  static const _kPad12 = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsListProvider);
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'Feed',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: _kPad12),
            child: SearchField(),
          ),
          Expanded(
            child: postsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Failed to load: $e'),
                    const SizedBox(height: _kPad24),
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
                            padding: const EdgeInsets.symmetric(
                              vertical: _kPad12,
                            ),
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
