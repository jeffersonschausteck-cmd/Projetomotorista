import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/supabase_client_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/clients/presentation/screens/clients_list_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/rides/presentation/screens/agenda_screen.dart';
import '../../features/vehicles/presentation/screens/vehicles_list_screen.dart';
import 'app_shell.dart';
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final client = ref.watch(supabaseClientProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(client.auth.onAuthStateChange),
    redirect: (context, state) {
      final isLoggedIn = client.auth.currentUser != null;
      final isAuthRoute =
          state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignupScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (_, _) => const DashboardScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/agenda', builder: (_, _) => const AgendaScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/clients', builder: (_, _) => const ClientsListScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/vehicles', builder: (_, _) => const VehiclesListScreen()),
            ],
          ),
        ],
      ),
    ],
  );
}
