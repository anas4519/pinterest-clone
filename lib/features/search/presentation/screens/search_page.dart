import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone/features/home/data/models/photo_model.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/custom_refresh.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_cart.dart';
import '../providers/search_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final state = ref.read(searchNotifierProvider);
      if (state.featuredPhotos.isEmpty || state.isSearching) return;

      final itemCount = state.featuredPhotos.take(8).length;
      final nextPage = (state.currentCarouselIndex + 1) % itemCount;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _restartAutoScroll() {
    _stopAutoScroll();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _searchController.dispose();
    _pageController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchNotifierProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: state.isLoading && state.featuredPhotos.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : PinterestRefreshIndicator(
              onRefresh: () async {},
              child: state.isSearching
                  ? _buildSearchMode(state, notifier)
                  : _buildMainContent(state, notifier),
            ),
    );
  }

  Widget _buildSearchMode(SearchState state, SearchNotifier notifier) {
    return SafeArea(
      child: Column(
        children: [
          _buildSearchBar(state, notifier, isOverlay: false),
          Expanded(child: _buildSearchResults(state)),
        ],
      ),
    );
  }

  Widget _buildMainContent(SearchState state, SearchNotifier notifier) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeaturedCarousel(state, notifier),

              const SizedBox(height: 16),
              _buildPageIndicator(state, notifier),

              const SizedBox(height: 24),
              _buildFeaturedBoardsSection(state),

              const SizedBox(height: 24),
              _buildIdeasForYouSection(state, notifier),

              const SizedBox(height: 100),
            ],
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: _buildSearchBar(state, notifier, isOverlay: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(
    SearchState state,
    SearchNotifier notifier, {
    bool isOverlay = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.secondary, width: 0.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(CupertinoIcons.search, color: theme.colorScheme.secondary),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: TextStyle(color: theme.colorScheme.secondary),
                decoration: InputDecoration(
                  hintText: 'Search for ideas',
                  hintStyle: TextStyle(color: theme.colorScheme.secondary),
                  border: InputBorder.none,
                  fillColor: theme.cardColor,
                ),
                onSubmitted: (value) => notifier.search(value),
                onChanged: (value) {
                  if (value.isEmpty) {
                    notifier.clearSearch();
                  }
                },
                onTap: () {
                  _stopAutoScroll();
                },
              ),
            ),
            if (state.isSearching)
              IconButton(
                icon: Icon(Icons.close, color: theme.colorScheme.secondary),
                onPressed: () {
                  _searchController.clear();
                  notifier.clearSearch();
                  _searchFocusNode.unfocus();
                  _restartAutoScroll();
                },
              )
            else
              Container(
                padding: const EdgeInsets.all(16),

                child: Icon(
                  Icons.camera_alt_outlined,
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel(SearchState state, SearchNotifier notifier) {
    final itemCount = state.featuredPhotos.take(8).length;

    return GestureDetector(
      onPanDown: (_) => _stopAutoScroll(),
      onPanEnd: (_) => _restartAutoScroll(),
      onPanCancel: () => _restartAutoScroll(),
      child: SizedBox(
        height: 480,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            notifier.updateCarouselIndex(index);
            _restartAutoScroll();
          },
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final photo = state.featuredPhotos[index];
            final category = notifier
                .featuredCategories[index % notifier.featuredCategories.length];

            return Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: photo.srcLarge,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[900],
                    child: const Icon(Icons.error, color: Colors.white),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.2, 0.6, 1.0],
                    ),
                  ),
                ),

                Positioned(
                  left: 16,
                  bottom: 24,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageIndicator(SearchState state, SearchNotifier notifier) {
    final itemCount = state.featuredPhotos.take(8).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: state.currentCarouselIndex == index ? 8 : 6,
          height: state.currentCarouselIndex == index ? 8 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state.currentCarouselIndex == index
                ? Colors.white
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedBoardsSection(SearchState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore featured boards',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'Ideas you might like',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: state.boards.length,
            itemBuilder: (context, index) {
              return _buildBoardCard(state.boards[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBoardCard(BoardModel board) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
              child: board.photos.length >= 3
                  ? Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CachedNetworkImage(
                            imageUrl: board.photos[0].srcMedium,
                            fit: BoxFit.cover,
                            height: 180,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[800]),
                          ),
                        ),
                        const SizedBox(width: 2),

                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: board.photos[1].srcMedium,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey[800]),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: board.photos[2].srcMedium,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : board.photos.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: board.photos[0].srcMedium,
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[800]),
                    )
                  : Container(color: Colors.grey[800]),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            board.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              Text(
                board.author,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (board.isVerified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.red, size: 14),
              ],
            ],
          ),
          const SizedBox(height: 2),

          Text(
            '${board.pinCount} Pins · ${board.timeAgo}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildIdeasForYouSection(SearchState state, SearchNotifier notifier) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ideas for you',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () => _searchForTopic('New poster', notifier),
                child: Row(
                  children: [
                    const Text(
                      'New poster',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        CupertinoIcons.search,
                        size: 18,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: state.ideasForYou.length,
            itemBuilder: (context, index) {
              final photo = state.ideasForYou[index];
              return GestureDetector(
                onTap: () => _searchForTopic('New poster', notifier),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: photo.srcMedium,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[800]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ideas for you',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () => _searchForTopic('Star Wars', notifier),
                child: Row(
                  children: [
                    const Text(
                      'Star Wars',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        CupertinoIcons.search,
                        size: 18,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: state.ideasForYou.length,
            itemBuilder: (context, index) {
              final photo = state.starWars[index];
              return GestureDetector(
                onTap: () => _searchForTopic('Star Wars', notifier),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: photo.srcMedium,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[800]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _searchForTopic(String topic, SearchNotifier notifier) {
    _stopAutoScroll();
    _searchController.text = topic;
    notifier.search(topic);
  }

  Widget _buildSearchResults(SearchState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (state.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              'No results found for "${state.searchQuery}"',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      itemCount: state.searchResults.length,
      itemBuilder: (context, index) {
        final photo = state.searchResults[index];
        return _buildSearchResultItem(photo);
      },
    );
  }

  Widget _buildSearchResultItem(PhotoModel photo) {
    return PinCard(photo: photo);
  }
}
