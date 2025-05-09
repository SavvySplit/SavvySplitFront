import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/features/auth/forgot_password_screen.dart';
import '../core/features/auth/login_screen.dart';
import '../core/features/auth/register_screen.dart';
import '../core/features/splash/splash_screen.dart';
import '../core/features/analytics/screens/analytics_screen.dart';
import '../core/features/budget/screens/budget_screen.dart';
import '../core/features/dashboard/screens/dashboard_screen.dart';
import '../core/features/goals/screens/goals_screen.dart';
import '../core/features/groups/screens/groups_screen.dart';
import '../core/features/settings/screens/settings_screen.dart';
import '../core/features/settings/screens/account_information_screen.dart';
import '../core/features/settings/screens/personal_information_screen.dart';
import '../core/features/wallet/screens/wallet_screen.dart';
import '../core/providers/tab_provider.dart';
import '../core/widgets/main_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: <RouteBase>[
    // Splash screen
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Auth routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Main app shell with bottom navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ChangeNotifierProvider(
          create: (_) => TabProvider(),
          child: MainScaffold(child: child),
        );
      },
      routes: [
        // Dashboard tab
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
          routes: [
            // Add sub-routes for dashboard if needed
          ],
        ),

        // Wallet tab
        GoRoute(
          path: '/wallet',
          builder: (context, state) => const WalletScreen(),
          routes: [
            // Add sub-routes for wallet if needed
          ],
        ),

        // Groups tab
        GoRoute(
          path: '/groups',
          builder: (context, state) => const GroupsScreen(),
          routes: [
            // Add sub-routes for groups if needed
          ],
        ),

        // Analytics tab
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
          routes: [
            // Add sub-routes for analytics if needed
          ],
        ),

        // Settings tab
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'account-information',
              builder: (context, state) => const AccountInformationScreen(),
            ),
            GoRoute(
              path: 'personal-information',
              builder: (context, state) => const PersonalInformationScreen(),
            ),
          ],
        ),
      ],
    ),

    // Additional standalone routes
    GoRoute(
      path: '/budget',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BudgetScreen(),
    ),
    GoRoute(
      path: '/goals',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const GoalsScreen(),
    ),
  ],
);
