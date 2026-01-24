import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/constants/api_constants.dart';
import 'package:pinterest_clone/core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_state_provider.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PinterestCloneApp()));
}

class PinterestCloneApp extends ConsumerStatefulWidget {
  const PinterestCloneApp({super.key});

  @override
  ConsumerState<PinterestCloneApp> createState() => _PinterestCloneAppState();
}

class _PinterestCloneAppState extends ConsumerState<PinterestCloneApp> {
  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    return ClerkAuth(
      config: ClerkAuthConfig(publishableKey: ApiConstants.clerkPublishableKey),
      child: Builder(
        builder: (context) {
          final authState = ClerkAuth.of(context);
          if (authState.user != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(authStateProvider.notifier).state = true;
            });
          }

          authState.addListener(() {
            final isLoggedIn = authState.user != null;
            ref.read(authStateProvider.notifier).state = isLoggedIn;
          });

          return MaterialApp.router(
            title: 'Pinterest Clone',
            debugShowCheckedModeBanner: false,
            routerConfig: goRouter,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
          );
        },
      ),
    );
  }
}
