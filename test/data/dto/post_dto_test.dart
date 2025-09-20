import 'package:flutter_test/flutter_test.dart';
import 'package:posts_list/data/dto/post_dto.dart';

void main() {
  group('PostDto', () {
    test('should parse JSON and trim strings', () {
      final dto = PostDto.fromJson({
        'userId': 1,
        'id': 4,
        'title': '  eum et est occaecati  ',
        'body': '  ullam et saepe reiciendis\nvoluptatem  ',
      });

      expect(dto.userId, 1);
      expect(dto.id, 4);
      expect(dto.title, 'eum et est occaecati');
      expect(dto.body, 'ullam et saepe reiciendis\nvoluptatem');
    });

    test('should apply sentence case to title, full and short in toDomain', () {
      final dto = PostDto(
        userId: 1,
        id: 10,
        title: 'hELLo',
        body: 'woRLD line one\nsecond',
      );
      final post = dto.toDomain(shortMaxLen: 50);

      expect(post.title, 'Hello');
      expect(post.fullDescription, 'World line one\nsecond');
      expect(post.shortDescription, 'World line one');
    });

    test(
      'should take first line for shortDescription when body has newlines',
      () {
        final dto = PostDto(
          userId: 1,
          id: 1,
          title: 'T',
          body: 'first line\nsecond line',
        );
        final post = dto.toDomain(shortMaxLen: 120);
        expect(post.shortDescription, 'First line');
      },
    );

    test('should handle Carriage Return + Line Feed line breaks', () {
      final dto = PostDto(
        userId: 1,
        id: 2,
        title: 'T',
        body: 'first\r\nsecond',
      );
      final post = dto.toDomain(shortMaxLen: 120);
      expect(post.shortDescription, 'First');
    });

    test('should clip at word boundary and append ellipsis when too long', () {
      final dto = PostDto(
        userId: 1,
        id: 3,
        title: 'T',
        body: 'this is a very long line with multiple words',
      );
      final post = dto.toDomain(shortMaxLen: 20);
      expect(post.shortDescription, 'This is a very long…');
    });

    test('should hard cut long single word and append ellipsis', () {
      final dto = PostDto(
        userId: 1,
        id: 4,
        title: 'T',
        body: 'SuperMegaUltraLongWordWithoutSpaces',
      );
      final post = dto.toDomain(shortMaxLen: 10);
      expect(post.shortDescription, 'Supermegau…');
    });

    test('should return empty shortDescription for empty body', () {
      final dto = PostDto(userId: 1, id: 5, title: 'T', body: '');
      final post = dto.toDomain(shortMaxLen: 50);
      expect(post.shortDescription, '');
    });
  });
}
