import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/ui/providers/theme_provider.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  static const double _kIconSize64 = 64;
  static const double _kIocnSize32 = 32;
  static const double _kIconSize = 24;

  static const double _kCircularRadius = 999;
  static const int _kAnimMs = 180;

  static const double kPad4 = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => ref.read(themeModeProvider.notifier).toggle(),
      child: SizedBox(
        width: _kIconSize64,
        height: _kIocnSize32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: _kAnimMs),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(_kCircularRadius),
              ),
              width: double.infinity,
              height: _kIocnSize32,
              padding: const EdgeInsets.symmetric(horizontal: kPad4),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.light_mode,
                        size: _kIconSize,
                        color: isDark ? cs.onSurfaceVariant : cs.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.dark_mode,
                        size: _kIconSize,
                        color: isDark ? cs.primary : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: _kAnimMs),
              curve: Curves.easeOut,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: _kIocnSize32,
                height: _kIocnSize32,
                decoration: BoxDecoration(
                  color: cs.surface,
                  border: Border.all(color: cs.outlineVariant),
                  borderRadius: BorderRadius.circular(_kCircularRadius),
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
