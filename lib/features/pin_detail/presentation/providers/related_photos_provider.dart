// lib/features/pin_detail/presentation/providers/related_photos_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/home/data/models/photo_model.dart';
import 'package:pinterest_clone/features/home/data/repositories/photo_repository_impl.dart';

final relatedPhotosProvider = FutureProvider.family<List<PhotoModel>, String>((
  ref,
  query,
) async {
  final repository = ref.read(photoRepositoryProvider);

  final searchQuery = query.isNotEmpty ? query : 'nature';

  return await repository.searchPhotos(
    query: searchQuery,
    page: 1,
    perPage: 20,
  );
});
