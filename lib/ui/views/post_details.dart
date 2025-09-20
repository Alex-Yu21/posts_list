import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/ui/views/providers/posts_providers.dart';

class PostDetailsView extends ConsumerWidget {
  final int id;
  const PostDetailsView({super.key, required this.id});

  static const _kPad24 = 24.0;
  static const _kPad12 = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPost = ref.watch(postDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text('Post #$id')),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: _kPad12),
              Text(p.fullDescription),
            ],
          ),
        ),
      ),
    );
  }
}
