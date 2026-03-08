import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/daily_feed_screen.dart';
import 'services/progress_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProgressService()),
      ],
      child: const PlanckApp(),
    ),
  );
}

class PlanckApp extends StatelessWidget {
  const PlanckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planck',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DailyFeedScreen(),

    );
  }
}

