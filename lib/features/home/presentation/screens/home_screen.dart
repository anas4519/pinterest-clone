import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/custom_refresh.dart'; // Ensure this matches your file name
import 'package:pinterest_clone/features/home/presentation/widgets/pin_cart.dart';
import '../providers/home_provider.dart';
import '../widgets/feed_shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photosAsync = ref.watch(homeFeedProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 10,
            title: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              labelPadding: const EdgeInsets.only(right: 16),
              padding: EdgeInsets.zero,
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
                Tab(height: 32, text: "For you"),
                Tab(height: 32, text: "DIY and Crafts"),
                Tab(height: 32, text: "My saves"),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_fix_high,
                  size: 18,
                  color: theme.iconTheme.color,
                ),
              ),
            ],
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            PinterestRefreshIndicator(
              onRefresh: () async {
                await ref.read(homeFeedProvider.notifier).refresh();
              },
              child: photosAsync.when(
                loading: () => const FeedShimmer(),
                error: (err, stack) => Center(child: Text("Error: $err")),
                data: (photos) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.axis == Axis.vertical &&
                          scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 200) {
                        ref.read(homeFeedProvider.notifier).loadMore();
                      }
                      return false;
                    },
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: photos.length + 1,
                      itemBuilder: (context, index) {
                        if (index == photos.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        }
                        return PinCard(photo: photos[index]);
                      },
                    ),
                  );
                },
              ),
            ),

            // --- Tab 2: DIY and Crafts ---
            PinterestRefreshIndicator(
              onRefresh: () async {
                await ref.read(homeFeedProvider.notifier).refresh();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // Pagination logic for the main vertical scroll
                  if (scrollInfo.metrics.axis == Axis.vertical &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                    ref.read(homeFeedProvider.notifier).loadMore();
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'DIY and Crafts',
                              style: theme.textTheme.displaySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('20 Pins', style: theme.textTheme.bodySmall),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Your Saves',
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(CupertinoIcons.arrow_right),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 120,

                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: 20,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return AspectRatio(
                              aspectRatio: 1 / 1.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(color: Colors.grey[300]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // 3. SPACER (Between Horizontal List and Main Grid)
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // 4. MAIN VERTICAL GRID (Existing)
                    photosAsync.when(
                      loading: () =>
                          const SliverToBoxAdapter(child: FeedShimmer()),
                      error: (err, stack) => SliverToBoxAdapter(
                        child: Center(child: Text("Error: $err")),
                      ),
                      data: (photos) {
                        return SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childCount: photos.length + 1,
                          itemBuilder: (context, index) {
                            if (index == photos.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              );
                            }
                            return PinCard(photo: photos[index], isPin: true);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            PinterestRefreshIndicator(
              onRefresh: () async {
                await ref.read(homeFeedProvider.notifier).refresh();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // Pagination logic for the main vertical scroll
                  if (scrollInfo.metrics.axis == Axis.vertical &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                    ref.read(homeFeedProvider.notifier).loadMore();
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'My Saves',
                              style: theme.textTheme.displaySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('79 Pins', style: theme.textTheme.bodySmall),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Your Saves',
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(CupertinoIcons.arrow_right),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 120,

                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: 20,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return AspectRatio(
                              aspectRatio: 1 / 1.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(color: Colors.grey[300]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // 3. SPACER (Between Horizontal List and Main Grid)
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // 4. MAIN VERTICAL GRID (Existing)
                    photosAsync.when(
                      loading: () =>
                          const SliverToBoxAdapter(child: FeedShimmer()),
                      error: (err, stack) => SliverToBoxAdapter(
                        child: Center(child: Text("Error: $err")),
                      ),
                      data: (photos) {
                        return SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childCount: photos.length + 1,
                          itemBuilder: (context, index) {
                            if (index == photos.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              );
                            }
                            return PinCard(photo: photos[index], isPin: true);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
