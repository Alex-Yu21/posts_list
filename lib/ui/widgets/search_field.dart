import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/app/theme/tokens.dart';
import 'package:posts_list/ui/providers/posts_providers.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({
    super.key,
    this.hint = 'Search by title',
    this.debounce = const Duration(milliseconds: 350),
  });

  final String hint;
  final Duration debounce;

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final _controller = TextEditingController();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () {
      ref.read(queryProvider.notifier).state = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: theme.textTheme.bodyLarge,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Tokens.r32),
        ),
        suffixIcon: _controller.text.isEmpty
            ? const Icon(Icons.search)
            : IconButton(
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
                icon: const Icon(Icons.close),
              ),
      ),
    );
  }
}
