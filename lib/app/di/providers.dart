import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:posts_list/data/data_sources/posts_remote.dart';
import 'package:posts_list/data/repositories/posts_repo_impl.dart';
import 'package:posts_list/domain/repositories/posts_repo.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final c = http.Client();
  ref.onDispose(c.close);
  return c;
});

final postsBaseUriProvider = Provider<Uri>(
  (ref) => Uri.parse('https://jsonplaceholder.typicode.com'),
);

final postsRemoteProvider = Provider<PostsRemote>((ref) {
  final client = ref.watch(httpClientProvider);
  final base = ref.watch(postsBaseUriProvider);
  return JsonPlaceholderPostsRemote(client, base: base);
});

final postsRepoProvider = Provider<PostsRepo>((ref) {
  final remote = ref.watch(postsRemoteProvider);
  return PostsRepoImpl(remote);
});
