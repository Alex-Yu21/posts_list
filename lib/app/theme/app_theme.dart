import 'package:flutter/material.dart';
import 'package:posts_list/app/theme/tokens.dart';

final class AppTheme {
  static TextTheme _override(TextTheme base) => base.copyWith(
    titleLarge: base.titleLarge?.copyWith(
      fontSize: Tokens.fs32,
      fontWeight: Tokens.fw700,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontSize: Tokens.fs24,
      fontWeight: Tokens.fw600,
    ),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: Tokens.fs24),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: Tokens.fs20),
  );

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: Tokens.seed,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: Tokens.fontFamily,
      textTheme: _override(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: scheme.surface,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: Tokens.seed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: Tokens.fontFamily,
      textTheme: _override(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: scheme.surface,
        centerTitle: true,
      ),
    );
  }
}
