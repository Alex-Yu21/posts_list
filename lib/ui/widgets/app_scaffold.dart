import 'package:flutter/material.dart';
import 'package:posts_list/app/theme/tokens.dart';
import 'package:posts_list/ui/widgets/theme_switch.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, required this.title});
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          ThemeSwitch(),
          SizedBox(width: Tokens.pad24),
        ],
        title: Text(title, style: theme.textTheme.titleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Tokens.pad24),
        child: child,
      ),
    );
  }
}
