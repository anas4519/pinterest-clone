import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.secondary;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            backgroundColor: theme.cardColor,
            height: 40,
            iconTheme: WidgetStateProperty.resolveWith((states) {
              return IconThemeData(color: iconColor, size: 28);
            }),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          destinations: [
            const NavigationDestination(
              icon: Icon(CupertinoIcons.house, size: 24),
              selectedIcon: Icon(CupertinoIcons.house_fill, size: 24),
              label: 'Home',
            ),

            const NavigationDestination(
              icon: Icon(CupertinoIcons.search, size: 24),
              selectedIcon: Icon(CupertinoIcons.search, size: 30, weight: 1800),
              label: 'Search',
            ),

            // 3. CREATE (+)
            const NavigationDestination(
              icon: Icon(Icons.add, size: 30),
              selectedIcon: Icon(Icons.add, size: 30),
              label: 'Create',
            ),

            // 4. MESSAGES
            const NavigationDestination(
              icon: Icon(CupertinoIcons.chat_bubble, size: 24),
              selectedIcon: Icon(CupertinoIcons.chat_bubble_fill, size: 24),
              label: 'Messages',
            ),

            // 5. PROFILE
            NavigationDestination(
              icon: _ProfileAvatar(isActive: false),
              selectedIcon: _ProfileAvatar(isActive: true),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final bool isActive;

  const _ProfileAvatar({required this.isActive});

  @override
  Widget build(BuildContext context) {
    const double size = 24;
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: borderColor, width: 2) : null,
      ),
      padding: isActive ? const EdgeInsets.all(2.0) : EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl:
              "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=150",
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[800]),
          errorWidget: (context, url, error) => const Icon(Icons.person),
        ),
      ),
    );
  }
}
