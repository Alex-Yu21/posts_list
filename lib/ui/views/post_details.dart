import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/ui/providers/posts_providers.dart';

class PostDetailsView extends ConsumerWidget {
  final int id;
  const PostDetailsView({super.key, required this.id});

  static const _kPad24 = 24.0;
  static const _kPad12 = 12.0;
  static const _radius = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncPost = ref.watch(postDetailProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: Text('Post #$id', style: theme.textTheme.titleMedium),
        centerTitle: true,
      ),
      body: asyncPost.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: FilledButton(
            onPressed: () => ref.refresh(postDetailProvider(id)),
            child: const Text('Retry'),
          ),
        ),
        data: (p) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _kPad24,
            vertical: _kPad12,
          ),
          // TODO: hero animation
          child: Material(
            color: theme.colorScheme.secondaryContainer,
            elevation: 1,
            borderRadius: BorderRadius.circular(_radius),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(_kPad24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title, style: theme.textTheme.titleLarge),
                    Divider(
                      thickness: 1,
                      indent: 24,
                      endIndent: 24,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(height: _kPad12),
                    Text(p.fullDescription, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
