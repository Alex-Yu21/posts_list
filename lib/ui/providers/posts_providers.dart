import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_list/app/di/providers.dart';
import 'package:posts_list/domain/entities/post_entity.dart';

final queryProvider = StateProvider<String>((_) => '');

final postsListProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final repo = ref.read(postsRepoProvider);
  final all = await repo.fetchAll();
  final q = ref.watch(queryProvider).trim().toLowerCase();
  if (q.isEmpty) return all;
  return all.where((p) => p.title.toLowerCase().contains(q)).toList();
});

final postDetailProvider = FutureProvider.autoDispose.family<Post, int>((
  ref,
  id,
) {
  final repo = ref.read(postsRepoProvider);
  return repo.getPost(id);
});
