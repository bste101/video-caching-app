import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import '../features/auth/presentation/page/login_page.dart';
import '../features/feed/presentation/page/feed_page.dart';
import '../features/feed/presentation/page/main_page.dart';

class AppRouter {
  static final _box = GetStorage();

  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final token = _box.read('auth_token');

      final isLoggingIn = state.matchedLocation == '/login';

      if (token == null && !isLoggingIn) {
        return '/login';
      }

      if (token != null && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const MainPage(),
      ),
      GoRoute(
        path: '/feed',
        builder: (context, state) {
          final initialIndex = state.extra as int? ?? 0;
          return FeedPage(initialIndex: initialIndex);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
    ],
  );
}
