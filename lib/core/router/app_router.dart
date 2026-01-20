import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/core/presentation/main_wrapper.dart';
import 'package:pinterest_clone/features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // 1. Watch the auth state. If this changes, the router rebuilds.
  final isLoggedIn = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/home',
    // 2. This is the "Redirect Logic"
    redirect: (context, state) {
      final isLoggingIn = state.uri.toString() == '/login';

      // If not logged in and not on login page -> Go to Login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in and on login page -> Go to Home
      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      // Otherwise, no change needed
      return null;
    },

    routes: [
      // --- Public Routes ---
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

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
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text("Home Feed"))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text("Search"))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/add',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text("Add"))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text("Account"))),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
