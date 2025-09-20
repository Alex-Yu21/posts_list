import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';
import 'package:posts_list/domain/entities/post_entity.dart';

@immutable
class PostDto {
  final int id;
  final int userId;
  final String title;
  final String body;

  const PostDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostDto.fromJson(Map<String, dynamic> j) => PostDto(
    id: j['id'] as int,
    userId: j['userId'] as int,
    title: (j['title'] as String).trim(),
    body: (j['body'] as String).trim(),
  );

  Post toDomain({int shortMaxLen = 120}) {
    final normTitle = _ensurePeriod(_sentenceCase(title));
    final normFull = _ensurePeriod(_sentenceCase(body));
    final normShort = _sentenceCase(_makeShort(body, shortMaxLen));
    return Post(
      id: id,
      title: normTitle,
      shortDescription: normShort,
      fullDescription: normFull,
    );
  }

  static String _makeShort(String text, int maxLen) {
    final t = text.trim();
    if (t.isEmpty) return '';
    final first = t.replaceAll('\r\n', '\n').split('\n').first.trim();
    if (first.length <= maxLen) return first;
    final cut = first.substring(0, maxLen);
    final safe = cut.replaceFirst(RegExp(r'\s+\S*$'), '');
    return '${(safe.isEmpty ? cut : safe).trimRight()}…';
  }

  static String _sentenceCase(String input) {
    final t = input.trim();
    if (t.isEmpty) return t;
    final lower = t.toLowerCase();
    final first = lower.characters.first.toUpperCase();
    final rest = lower.characters.skip(1).toString();
    return '$first$rest';
  }

  static String _ensurePeriod(String input) {
    final t = input.trimRight();
    if (t.isEmpty) return t;
    final endsWithPunct = RegExp(r'[.!?…]$').hasMatch(t);
    return endsWithPunct ? t : '$t.';
  }
}
