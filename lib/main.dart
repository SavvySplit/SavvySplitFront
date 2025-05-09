import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/theme/app_theme.dart';
import 'core/providers/budget_provider.dart';
import 'core/providers/goal_provider.dart';
import 'core/providers/tab_provider.dart';
import 'core/providers/transaction_provider.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/dashboard_provider.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider()..initialize(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'SavvySplit',
        theme: AppTheme.lightTheme(context),
        darkTheme: AppTheme.darkTheme(context),
        themeMode: ThemeMode.dark, // Always use dark theme
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
