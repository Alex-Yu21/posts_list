import 'package:posts_list/data/data_sources/posts_remote.dart';
import 'package:posts_list/domain/entities/post_entity.dart';
import 'package:posts_list/domain/repositories/posts_repo.dart';

class PostsRepoImpl implements PostsRepo {
  final PostsRemote remote;

  List<Post>? _postsCache;
  Map<int, Post>? _postByIdCache;

  PostsRepoImpl(this.remote);

  @override
  Future<List<Post>> fetchAll() async {
    if (_postsCache != null) return _postsCache!;
    final fetched = await remote.fetchAll();
    _postsCache = List.unmodifiable(fetched);
    _postByIdCache = {for (final p in fetched) p.id: p};
    return _postsCache!;
  }

  @override
  Future<Post> getPost(int id) async {
    final cachedPost = _postByIdCache?[id];
    if (cachedPost != null) return cachedPost;

    final remotePost = await remote.fetchById(id);

    (_postByIdCache ??= {})[id] = remotePost;
    return remotePost;
  }
}
