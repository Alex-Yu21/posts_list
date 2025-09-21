import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/app/theme/tokens.dart';
import 'package:posts_list/ui/providers/theme_provider.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => ref.read(themeModeProvider.notifier).toggle(),
      child: SizedBox(
        width: Tokens.icon64,
        height: Tokens.icon32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: Tokens.anim180ms,
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(Tokens.rCircular),
              ),
              width: double.infinity,
              height: Tokens.icon32,
              padding: const EdgeInsets.symmetric(horizontal: Tokens.pad4),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.light_mode,
                        size: Tokens.icon24,
                        color: isDark ? cs.onSurfaceVariant : cs.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.dark_mode,
                        size: Tokens.icon24,
                        color: isDark ? cs.primary : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedAlign(
              duration: Tokens.anim180ms,
              curve: Curves.easeOut,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: Tokens.icon32,
                height: Tokens.icon32,
                decoration: BoxDecoration(
                  color: cs.surface,
                  border: Border.all(color: cs.outlineVariant),
                  borderRadius: BorderRadius.circular(Tokens.rCircular),
                  boxShadow: kElevationToShadow[1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
