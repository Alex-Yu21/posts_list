import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/ui/providers/theme_provider.dart';
import 'package:posts_list/ui/views/posts_list_view.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  static const _seed = Color.fromARGB(255, 111, 111, 158);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    final lightScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );

    TextTheme override(TextTheme base) => base.copyWith(
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      bodyLarge: base.bodyLarge?.copyWith(fontSize: 24),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 20),
    );

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        fontFamily: 'Copse',
        textTheme: override(ThemeData.light().textTheme),
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,

          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          centerTitle: true,
        ),
        useMaterial3: true,
        colorScheme: darkScheme,
        fontFamily: 'Copse',
        textTheme: override(ThemeData.dark().textTheme),
      ),
      themeMode: mode,
      home: const PostsListView(),
    );
  }
}
