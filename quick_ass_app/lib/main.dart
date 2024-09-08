
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/controllers/shared_gradient_controller.dart';
import 'package:quick_ass_app/providers/auth_provider.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';
import 'package:quick_ass_app/routes/index.dart';
import 'package:quick_ass_app/themes/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider())
      ],
      child: const QuickAssApp(),
    ),
  );
}

class QuickAssApp extends StatefulWidget {
  const QuickAssApp({super.key});

  @override
  _QuickAssAppState createState() => _QuickAssAppState();
}

class _QuickAssAppState extends State<QuickAssApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SharedGradientController(vsync: this),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: router,
      ),
    );
  }
}