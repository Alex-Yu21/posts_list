import 'package:flutter/material.dart';
import 'package:posts_list/ui/widgets/theme_switch.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, required this.title});
  final Widget child;
  final String title;

  static const _kPad24 = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          ThemeSwitch(),
          SizedBox(width: _kPad24),
        ],
        title: Text(title, style: theme.textTheme.titleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kPad24),
        child: child,
      ),
    );
  }
}
