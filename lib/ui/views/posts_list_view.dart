import 'package:flutter/material.dart';
import 'package:posts_list/domain/entities/post_entity.dart';

class PostsListView extends StatelessWidget {
  const PostsListView({super.key});

  // Future<List<Post>> _load() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),

      body: FutureBuilder<List<Post>>(
        future: null,
        // _load(),
        builder: (context, snap) {
          return Center(child: Text(''));
        },
      ),
    );
  }
}
