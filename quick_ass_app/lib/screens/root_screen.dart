import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/providers/auth_provider.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';
import 'package:quick_ass_app/providers/users_connection_provider.dart';
import 'package:quick_ass_app/routes/index.dart';
import 'package:quick_ass_app/services/geolocator.dart';
import 'package:quick_ass_app/services/package.dart';
import 'package:quick_ass_app/utils/svg_cacher.dart';
import 'package:shake/shake.dart';

import 'splash/index.dart';
import 'home/index.dart';
import 'onboarding/index.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    // // Initialize ShakeDetector to start detecting shakes
    // detector = ShakeDetector.autoStart(
    //   onPhoneShake: () async {
    //     WidgetsBinding.instance.addPostFrameCallback((_) async {
    //       if (!context.read<UsersConnectionProvider>().isConnected) {
    //         context.read<UsersConnectionProvider>().connectToSocket();
    //       }
    //
    //       final RouteMatch lastMatch = router.routerDelegate.currentConfiguration.last;
    //       final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : router.routerDelegate.currentConfiguration;
    //       final String location = matchList.uri.toString();
    //
    //       if (location == '/home') {
    //         final position = await determinePosition();
    //
    //         // Perform context operation after the frame has been rendered
    //         if (mounted) {
    //           context.read<UsersConnectionProvider>().sendLocationData(position,
    //               'fake eth address'); // Update provider appropriately
    //         }
    //       } else {
    //         Fluttertoast.showToast(
    //           msg: "💃 shake it off! connect your wallet first to unlock this feature",
    //           toastLength: Toast.LENGTH_SHORT,
    //           gravity: ToastGravity.TOP,
    //           timeInSecForIosWeb: 1,
    //           backgroundColor: Colors.white,
    //           textColor: Colors.black,
    //           fontSize: 14.0,
    //         );
    //       }
    //     });
    //   },
    //     );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return StreamBuilder<InternetConnectionStatus>(
        stream: InternetConnectionChecker().onStatusChange,
        builder: (context, connectionSnapshot) {
          if (connectionSnapshot.connectionState == ConnectionState.active) {
            final status = connectionSnapshot.data;
            final hasConnection = status == InternetConnectionStatus.connected;
            if (hasConnection) {
              Future.microtask(() async {
                await Future.wait([
                  Package().load(),
                  SvgCache().cacheIcons(),
                ]);
              });
            }
          }
          return FutureBuilder<bool>(
            future: authProvider.authentiacted(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Splash();
              } else if (snapshot.hasData && snapshot.data == true) {
                return const Home();
              } else {
                return const Onboarding();
              }
            },
          );
        },
      );
    });
  }
}
