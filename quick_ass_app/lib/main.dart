
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/controllers/shared_gradient_controller.dart';
import 'package:quick_ass_app/providers/auth_provider.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';
import 'package:quick_ass_app/providers/users_connection_provider.dart';
import 'package:quick_ass_app/routes/index.dart';
import 'package:quick_ass_app/services/geolocator.dart';
import 'package:quick_ass_app/services/package.dart';
import 'package:quick_ass_app/themes/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shake/shake.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Package().init();


  ShakeDetector.autoStart(
    onPhoneShake: () async {
      final context = navigatorKey.currentState?.context;
        if (!context!.read<UsersConnectionProvider>().isConnected) {
          context?.read<UsersConnectionProvider>().connectToSocket();
        }

        final RouteMatch lastMatch = router.routerDelegate.currentConfiguration.last;
        final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : router.routerDelegate.currentConfiguration;
        final String location = matchList.uri.toString();

        if (location == '/home') {
          Fluttertoast.showToast(
            msg: "Searching for nearby users...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 14.0,
          );
          final position = await determinePosition();

          final ethaddress = extractEthereumAddress(context?.read<ConnectionProvider>().sessionData?.namespaces['eip155']!.accounts.first ?? '');
          // Perform context operation after the frame has been rendered
            context?.read<UsersConnectionProvider>().sendLocationData(position,
                ethaddress); // Update provider appropriately

        } else {
          Fluttertoast.showToast(
            msg: "💃 shake it off! connect your wallet first to unlock this feature",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 14.0,
          );
        }
      });


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => UsersConnectionProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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


String extractEthereumAddress(String eip155Address) {
  // Split the string by the colon separator
  final parts = eip155Address.split(':');

  // Return the last part, which is the Ethereum address
  return parts.length > 2 ? parts.last : eip155Address;
}
