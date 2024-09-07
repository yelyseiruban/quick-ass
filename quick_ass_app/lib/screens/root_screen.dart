import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/providers/auth_provider.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';
import 'package:quick_ass_app/services/package.dart';
import 'package:quick_ass_app/utils/svg_cacher.dart';

import 'splash/index.dart';
import 'home/index.dart';
import 'onboarding/index.dart';


class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return StreamBuilder<InternetConnectionStatus>(
        stream: InternetConnectionChecker().onStatusChange,
        builder: (context, connectionSnapshot) {
          if (connectionSnapshot.connectionState == ConnectionState.active) {
            final status = connectionSnapshot.data;
            final hasConnection = status == InternetConnectionStatus.connected;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<ConnectionProvider>(context, listen: false)
                  .setConnection(hasConnection);
            });
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
              if (snapshot.connectionState == ConnectionState.waiting || connectionSnapshot.data == InternetConnectionStatus.disconnected) {
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
