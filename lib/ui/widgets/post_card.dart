import 'package:flutter/material.dart';
import 'package:posts_list/app/theme/tokens.dart';
import 'package:posts_list/domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, this.onTap});

  final Post post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Hero(
      tag: post.id,
      child: Material(
        color: theme.colorScheme.secondaryContainer,
        elevation: 1,
        borderRadius: BorderRadius.circular(Tokens.r16),
        child: InkWell(
          borderRadius: BorderRadius.circular(Tokens.r16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Tokens.pad12),
            child: SizedBox(
              height: Tokens.card116,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          post.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(height: Tokens.pad12),
                        Text(
                          '${post.shortDescription}...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
