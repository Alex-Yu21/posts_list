import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posts_list/data/dto/post_dto.dart';
import 'package:posts_list/domain/entities/post_entity.dart';

abstract class PostsRemote {
  Future<List<Post>> fetchAll();
  Future<Post> fetchById(int id);
}

class JsonPlaceholderPostsRemote implements PostsRemote {
  final http.Client _client;
  final Uri _base;

  JsonPlaceholderPostsRemote(this._client, {Uri? base})
    : _base = base ?? Uri.parse('https://jsonplaceholder.typicode.com');

  @override
  Future<List<Post>> fetchAll() async {
    final uri = _base.replace(path: '/posts');
    final resp = await _client
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 8));

    if (resp.statusCode != 200) {
      throw Exception('Remote error [GET /posts] (${resp.statusCode})');
    }

    final decoded = json.decode(resp.body) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map((j) => PostDto.fromJson(j).toDomain())
        .toList();
  }

  @override
  Future<Post> fetchById(int id) async {
    final uri = _base.replace(path: '/posts/$id');
    final resp = await _client
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 8));

    if (resp.statusCode != 200) {
      throw Exception('Remote error [GET /posts/$id] (${resp.statusCode})');
    }

    final decoded = json.decode(resp.body) as Map<String, dynamic>;
    return PostDto.fromJson(decoded).toDomain();
  }
}
