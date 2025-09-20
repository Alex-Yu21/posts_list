import 'package:posts_list/domain/entities/post_entity.dart';

abstract class PostsRepo {
  Future<List<Post>> fetchAll();

  Future<Post> getPost(int id);
}
