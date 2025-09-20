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

  factory PostDto.fromJson(Map<String, dynamic> json) => PostDto(
    id: json['id'] as int,
    userId: json['userId'] as int,
    title: (json['title'] as String).trim(),
    body: (json['body'] as String).trim(),
  );

  Post toDomain({int shortMaxLen = 120}) => Post(
    id: id,
    title: title,
    shortDescription: _makeShort(body, shortMaxLen),
    fullDescription: body,
  );

  static String _makeShort(String text, int maxLen) {
    final firstLine = text.replaceAll('\r\n', '\n').split('\n').first.trim();
    if (firstLine.length <= maxLen) return firstLine;
    final clipped = firstLine.substring(0, maxLen);
    final safe = clipped.replaceFirst(RegExp(r'\s+\S*$'), '');
    return '${(safe.isEmpty ? clipped : safe).trimRight()}…';
  }
}
