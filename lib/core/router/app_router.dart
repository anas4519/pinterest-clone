import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/presentation/main_wrapper.dart';
import 'package:pinterest_clone/features/account/presentation/screens/account_screen.dart';
import 'package:pinterest_clone/features/account/presentation/screens/account_settings_page.dart';
import 'package:pinterest_clone/features/auth/presentation/screens/login_screen.dart';
import 'package:pinterest_clone/features/chat/presentation/screens/chat_screen.dart';
import 'package:pinterest_clone/features/home/data/models/photo_model.dart';
import 'package:pinterest_clone/features/home/presentation/screens/home_screen.dart';
import 'package:pinterest_clone/features/pin_detail/presentation/screens/pin_detail_screen.dart';
import 'package:pinterest_clone/features/search/presentation/screens/search_page.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggingIn = state.uri.toString() == '/login';
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }
      return null;
    },

    routes: [
      // --- Public Routes ---
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // --- Profile Route without ID (for current user) ---
      GoRoute(
        path: '/profile',
        name: 'myProfile',
        builder: (context, state) => const AccountSettingsPage(),
      ),

      GoRoute(
        path: '/pin/:photoId',
        name: 'pinDetail',
        builder: (context, state) {
          final photo = state.extra as PhotoModel;
          return PinDetailScreen(photo: photo);
        },
      ),

      // --- Protected Routes (The Shell) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
