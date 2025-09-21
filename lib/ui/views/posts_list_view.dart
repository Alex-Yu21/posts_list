import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/ui/providers/posts_providers.dart';
import 'package:posts_list/ui/views/post_details.dart';
import 'package:posts_list/ui/widgets/post_card.dart';
import 'package:posts_list/ui/widgets/rheme_switch.dart';

class PostsListView extends ConsumerWidget {
  const PostsListView({super.key});

  static const _kPad24 = 24.0;
  static const _kPad12 = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsListProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            ThemeSwitch(),
            SizedBox(width: _kPad24),
          ],
          title: Text('Feed', style: theme.textTheme.titleMedium),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kPad24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: _kPad12),
                child: TextField(
                  // TODO: separete wodjet + debaunce
                  decoration: InputDecoration(
                    hintText: 'Search by title',
                    hintStyle: theme.textTheme.bodyLarge,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onChanged: (v) => ref.read(queryProvider.notifier).state = v,
                ),
              ),
              Expanded(
                child: postsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
                                // TODO: hero animation
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
        ),
      ),
    );
  }
}
