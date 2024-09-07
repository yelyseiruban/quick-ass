
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/controllers/shared_gradient_controller.dart';
import 'package:quick_ass_app/routes/index.dart';
import 'package:quick_ass_app/themes/index.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        // TBD tbc
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