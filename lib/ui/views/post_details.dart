import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/app/theme/tokens.dart';
import 'package:posts_list/ui/providers/posts_providers.dart';
import 'package:posts_list/ui/widgets/app_scaffold.dart';

class PostDetailsView extends ConsumerWidget {
  final int id;
  const PostDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncPost = ref.watch(postDetailProvider(id));
    return AppScaffold(
      title: 'Post #$id',
      child: asyncPost.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: FilledButton(
            onPressed: () => ref.refresh(postDetailProvider(id)),
            child: const Text('Retry'),
          ),
        ),
        data: (p) => Padding(
          padding: const EdgeInsets.symmetric(vertical: Tokens.pad12),
          child: Hero(
            tag: p.id,
            child: Material(
              color: theme.colorScheme.secondaryContainer,
              elevation: 1,
              borderRadius: BorderRadius.circular(Tokens.r16),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Tokens.pad24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.title, style: theme.textTheme.titleLarge),
                      Divider(
                        thickness: 1,
                        indent: Tokens.pad24,
                        endIndent: Tokens.pad24,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(height: Tokens.pad12),
                      Text(p.fullDescription, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
