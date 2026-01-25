import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/presentation/widgets/create_bottom_sheet.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  void _goBranch(BuildContext context, int index) {
    if (index == 2) {
      CreateBottomSheet.show(context);
      return;
    }

    final branchIndex = index > 2 ? index - 1 : index;
    navigationShell.goBranch(branchIndex);
  }

  int _getNavBarIndex(int branchIndex) {
    return branchIndex >= 2 ? branchIndex + 1 : branchIndex;
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
          selectedIndex: _getNavBarIndex(navigationShell.currentIndex),
          onDestinationSelected: (index) => _goBranch(context, index),
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

            const NavigationDestination(
              icon: Icon(Icons.add, size: 30),
              selectedIcon: Icon(Icons.add, size: 30),
              label: 'Create',
            ),

            const NavigationDestination(
              icon: Icon(CupertinoIcons.chat_bubble, size: 24),
              selectedIcon: Icon(CupertinoIcons.chat_bubble_fill, size: 24),
              label: 'Messages',
            ),

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
      child: CircleAvatar(
        radius: 8,
        child: Text('A', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
