import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:posts_list/data/data_sources/posts_remote.dart';

void main() {
  group('JsonPlaceholderPostsRemote', () {
    test('should return list of posts on 200 with valid JSON', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), 'https://example.com/posts');
        expect(request.headers['Accept'], 'application/json');

        final body = jsonEncode([
          {'userId': 1, 'id': 1, 'title': 'T', 'body': 'B'},
          {'userId': 2, 'id': 2, 'title': 'X', 'body': 'Y'},
        ]);
        return http.Response(
          body,
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final remote = JsonPlaceholderPostsRemote(
        client,
        base: Uri.parse('https://example.com'),
      );

      final list = await remote.fetchAll();
      expect(list.length, 2);
      expect(list.first.title, 'T');
    });

    test('should throw Exception on non-200 for fetchById', () async {
      final client = MockClient((request) async {
        return http.Response('oops', 500);
      });

      final remote = JsonPlaceholderPostsRemote(
        client,
        base: Uri.parse('https://example.com'),
      );

      await expectLater(remote.fetchById(1), throwsA(isA<Exception>()));
    });
  });
}
