import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/photo_repository_impl.dart';
import '../../data/models/photo_model.dart';

final homeFeedProvider =
    AsyncNotifierProvider<HomeFeedNotifier, List<PhotoModel>>(() {
      return HomeFeedNotifier();
    });

class HomeFeedNotifier extends AsyncNotifier<List<PhotoModel>> {
  int _page = 1;
  bool _isLoadingMore = false;

  @override
  Future<List<PhotoModel>> build() async {
    _page = 1;
    return _fetchPhotos(page: 1);
  }

  Future<List<PhotoModel>> _fetchPhotos({required int page}) async {
    final repo = ref.read(photoRepositoryProvider);
    return await repo.getCuratedPhotos(page: page);
  }

  Future<void> loadMore() async {
    if (_isLoadingMore ||
        state.isLoading ||
        state.hasError ||
        state.value == null) {
      return;
    }

    _isLoadingMore = true;

    try {
      final nextPage = _page + 1;
      final newPhotos = await _fetchPhotos(page: nextPage);

      if (newPhotos.isNotEmpty) {
        _page = nextPage;
        final currentList = state.value!;
        state = AsyncValue.data([...currentList, ...newPhotos]);
      }
    } catch (e) {
      print("Pagination Error: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    _page = 1;
    state = const AsyncValue.loading();
    try {
      final newPhotos = await _fetchPhotos(page: 1);
      state = AsyncValue.data(newPhotos);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
