import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/features/home/data/models/photo_model.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/feed_shimmer.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _AccountHeader(
              tabController: _tabController,
              showSearchBar: _tabController.index != 2,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [_PinsTab(), _BoardsTab(), _CollagesTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  final TabController tabController;
  final bool showSearchBar;

  const _AccountHeader({
    required this.tabController,
    this.showSearchBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.push('/profile');
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.primaryColor.withOpacity(0.8),
                  child: Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: TabBar(
                  controller: tabController,
                  isScrollable: false,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  indicatorColor: theme.colorScheme.secondary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: theme.colorScheme.secondary,
                  unselectedLabelColor: theme.colorScheme.secondary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Pins'),
                    Tab(text: 'Boards'),
                    Tab(text: 'Collages'),
                  ],
                ),
              ),
            ],
          ),
          if (showSearchBar) ...[
            const SizedBox(height: 16),
            const _SearchBar(),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.secondary,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(
                  CupertinoIcons.search,
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search your Pins',
                  style: TextStyle(
                    color: theme.colorScheme.secondary.withOpacity(0.6),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 44,
          height: 44,

          child: Icon(Icons.add, color: theme.colorScheme.secondary, size: 36),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon2;
  final Color? bgColor;

  const _FilterChip({
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.icon2,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              bgColor ??
              (isSelected ? theme.colorScheme.secondary : theme.cardColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: label.isEmpty && icon2 == null
            ? Icon(
                icon,
                size: 18,
                color: isSelected
                    ? theme.scaffoldBackgroundColor
                    : theme.colorScheme.secondary,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                      color: isSelected
                          ? theme.scaffoldBackgroundColor
                          : theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (icon2 != null) ...[
                    Icon(
                      icon2,
                      size: 18,
                      color: isSelected
                          ? theme.scaffoldBackgroundColor
                          : theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? theme.scaffoldBackgroundColor
                          : theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PinsTab extends ConsumerWidget {
  const _PinsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final photosAsync = ref.watch(homeFeedProvider);

    return photosAsync.when(
      loading: () => const FeedShimmer(),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (photos) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _FilterChip(
                      icon: Icons.grid_view_rounded,
                      label: '',
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      icon: Icons.star,
                      label: 'Favourites',
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Created by you', onTap: () {}),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Board suggestions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _BoardSuggestionCard(
                  title: 'Michael jackson w...',
                  pinCount: 3,
                  images: photos.take(4).map((p) => p.srcMedium).toList(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Your saved Pins',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childCount: photos.length,
                itemBuilder: (context, index) {
                  return _PinGridItem(photo: photos[index]);
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }
}

class _PinGridItem extends StatelessWidget {
  final PhotoModel photo;

  const _PinGridItem({required this.photo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/pin/${photo.id}', extra: photo);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: photo.srcMedium,
          fit: BoxFit.cover,
          placeholder: (context, url) => AspectRatio(
            aspectRatio: 1,
            child: Container(color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }
}

class _BoardSuggestionCard extends StatelessWidget {
  final String title;
  final int pinCount;
  final List<String> images;

  const _BoardSuggestionCard({
    required this.title,
    required this.pinCount,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 120,
                  width: 180,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: _buildImage(
                                images.isNotEmpty ? images[0] : '',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Expanded(
                              child: _buildImage(
                                images.length > 2 ? images[2] : '',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: _buildImage(
                                images.length > 1 ? images[1] : '',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Expanded(
                              child: _buildImage(
                                images.length > 3 ? images[3] : '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Create',
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Text('$pinCount Pins', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return Container(color: Colors.grey[800]);
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(color: Colors.grey[800]),
    );
  }
}

class _BoardsTab extends ConsumerWidget {
  const _BoardsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final photosAsync = ref.watch(homeFeedProvider);

    return photosAsync.when(
      loading: () => const FeedShimmer(),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (photos) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _FilterChip(
                      icon: Icons.swap_vert,
                      label: '',
                      onTap: () {},
                      isSelected: true,
                      icon2: Icons.arrow_downward_outlined,
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Group', onTap: () {}),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildListDelegate([
                  _BoardCard(
                    title: 'DIY and Crafts',
                    pinCount: 20,
                    timeAgo: '2d',
                    images: photos.take(4).map((p) => p.srcMedium).toList(),
                  ),
                  _BoardCard(
                    title: 'My saves',
                    pinCount: 79,
                    timeAgo: '1mo',
                    images: photos
                        .skip(4)
                        .take(4)
                        .map((p) => p.srcMedium)
                        .toList(),
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Board suggestions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _BoardSuggestionCard(
                  title: 'Michael jackson w...',
                  pinCount: 3,
                  images: photos
                      .skip(8)
                      .take(4)
                      .map((p) => p.srcMedium)
                      .toList(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }
}

class _BoardCard extends StatelessWidget {
  final String title;
  final int pinCount;
  final String timeAgo;
  final List<String> images;

  const _BoardCard({
    required this.title,
    required this.pinCount,
    required this.timeAgo,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildImage(images.isNotEmpty ? images[0] : ''),
                ),
                const SizedBox(width: 2),

                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildImage(images.length > 1 ? images[1] : ''),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: _buildImage(images.length > 2 ? images[2] : ''),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        Row(
          children: [
            Text(
              '$pinCount Pins  ',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 12,
              ),
            ),
            Text(
              timeAgo,
              style: TextStyle(
                color: theme.colorScheme.secondary.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return Container(color: Colors.grey[800]);
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(color: Colors.grey[800]),
    );
  }
}

class _CollagesTab extends StatelessWidget {
  const _CollagesTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(label: 'Created by you', onTap: () {}),
                const SizedBox(width: 8),
                _FilterChip(label: 'In progress', onTap: () {}),
              ],
            ),
          ),
        ),

        SliverFillRemaining(hasScrollBody: false, child: _CollagesEmptyState()),
      ],
    );
  }
}

class _CollagesEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5B4FE9),
                  Color(0xFF8B5CF6),
                  Color(0xFFEC4899),
                  Color(0xFFF97316),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 30,
                  left: 30,
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF93C5FD).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 40,
                  child: Container(
                    width: 50,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDA4AF).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  right: 35,
                  child: Container(
                    width: 45,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCD34D).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                Icon(Icons.content_cut, size: 48, color: Colors.grey[600]),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'Make your first collage',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          Text(
            'Snip and paste the best parts of your favourite Pins to create something completely new.',
            style: TextStyle(fontSize: 15, height: 1.4),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Create collage',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
