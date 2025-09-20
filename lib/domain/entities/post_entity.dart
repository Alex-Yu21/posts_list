import 'package:flutter/foundation.dart';

@immutable
class Post {
  final int id;
  final String title;
  final String shortDescription;
  final String fullDescription;

  const Post({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post &&
        other.id == id &&
        other.title == title &&
        other.shortDescription == shortDescription &&
        other.fullDescription == fullDescription;
  }

  @override
  int get hashCode => Object.hash(id, title, shortDescription, fullDescription);

  @override
  String toString() => 'Post(id: $id, title: $title, short: $shortDescription)';
}
