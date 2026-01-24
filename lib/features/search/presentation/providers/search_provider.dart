import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest_clone/features/home/data/models/photo_model.dart';
import 'package:pinterest_clone/features/home/data/repositories/photo_repository_impl.dart';

class FeaturedCategory {
  final String title;
  final String subtitle;
  final String query;
  final String? imageUrl;

  FeaturedCategory({
    required this.title,
    required this.subtitle,
    required this.query,
    this.imageUrl,
  });
}

class BoardModel {
  final String title;
  final String author;
  final int pinCount;
  final String timeAgo;
  final List<PhotoModel> photos;
  final bool isVerified;

  BoardModel({
    required this.title,
    required this.author,
    required this.pinCount,
    required this.timeAgo,
    required this.photos,
    this.isVerified = false,
  });
}

class SearchState {
  final List<PhotoModel> featuredPhotos;
  final List<BoardModel> boards;
  final List<PhotoModel> ideasForYou;
  final List<PhotoModel> starWars;
  final List<PhotoModel> searchResults;
  final bool isLoading;
  final bool isSearching;
  final String? error;
  final String searchQuery;
  final int currentCarouselIndex;

  SearchState({
    this.featuredPhotos = const [],
    this.boards = const [],
    this.ideasForYou = const [],
    this.starWars = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.error,
    this.searchQuery = '',
    this.currentCarouselIndex = 0,
  });

  SearchState copyWith({
    List<PhotoModel>? featuredPhotos,
    List<BoardModel>? boards,
    List<PhotoModel>? ideasForYou,
    List<PhotoModel>? starWars,
    List<PhotoModel>? searchResults,

    bool? isLoading,
    bool? isSearching,
    String? error,
    String? searchQuery,
    int? currentCarouselIndex,
  }) {
    return SearchState(
      featuredPhotos: featuredPhotos ?? this.featuredPhotos,
      boards: boards ?? this.boards,
      ideasForYou: ideasForYou ?? this.ideasForYou,
      starWars: starWars ?? this.starWars,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      currentCarouselIndex: currentCarouselIndex ?? this.currentCarouselIndex,
    );
  }
}

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
      return SearchNotifier(ref.read(photoRepositoryProvider));
    });

class SearchNotifier extends StateNotifier<SearchState> {
  final PhotoRepositoryImpl _repository;

  SearchNotifier(this._repository) : super(SearchState()) {
    loadInitialData();
  }

  final List<FeaturedCategory> featuredCategories = [
    FeaturedCategory(
      title: 'DIY manicure ideas',
      subtitle: 'Nailed it!',
      query: 'manicure nails',
    ),
    FeaturedCategory(
      title: 'Home decor inspiration',
      subtitle: 'Make it cozy',
      query: 'home decor',
    ),
    FeaturedCategory(
      title: 'Healthy recipes',
      subtitle: 'Eat well',
      query: 'healthy food',
    ),
    FeaturedCategory(
      title: 'Workout motivation',
      subtitle: 'Stay fit',
      query: 'fitness workout',
    ),
    FeaturedCategory(
      title: 'Travel destinations',
      subtitle: 'Wanderlust',
      query: 'travel landscape',
    ),
  ];

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final featured = await _repository.getCuratedPhotos(page: 1, perPage: 8);

      final boardQueries = ['yoga', 'celebration', 'nature', 'art'];
      List<BoardModel> boards = [];

      for (int i = 0; i < boardQueries.length; i++) {
        final photos = await _repository.searchPhotos(
          query: boardQueries[i],
          page: 1,
          perPage: 4,
        );

        boards.add(
          BoardModel(
            title: _getBoardTitle(boardQueries[i]),
            author: 'Pinterest User',
            pinCount: 41,
            timeAgo: '2d',
            photos: photos,
            isVerified: i % 2 == 0,
          ),
        );
      }

      final ideas = await _repository.searchPhotos(
        query: 'poster art',
        page: 1,
        perPage: 10,
      );
      final starWars = await _repository.searchPhotos(
        query: 'star wars',
        page: 1,
        perPage: 10,
      );

      state = state.copyWith(
        featuredPhotos: featured,
        boards: boards,
        ideasForYou: ideas,
        starWars: starWars,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  String _getBoardTitle(String query) {
    switch (query) {
      case 'yoga':
        return 'Yoga mornings aesthetic';
      case 'celebration':
        return 'Celebrating Republic Day';
      case 'nature':
        return 'Nature escapes';
      case 'art':
        return 'Art inspiration';
      default:
        return query;
    }
  }

  void updateCarouselIndex(int index) {
    state = state.copyWith(currentCarouselIndex: index);
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        isSearching: false,
        searchQuery: '',
        searchResults: [],
      );
      return;
    }

    state = state.copyWith(
      isSearching: true,
      searchQuery: query,
      isLoading: true,
    );

    try {
      final results = await _repository.searchPhotos(query: query, perPage: 30);
      state = state.copyWith(searchResults: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearSearch() {
    state = state.copyWith(
      isSearching: false,
      searchQuery: '',
      searchResults: [],
    );
  }
}
