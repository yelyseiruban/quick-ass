import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/constants/image.uri.dart';
import 'package:quick_ass_app/services/package.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';

class Splash extends StatelessWidget {
  const Splash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isConnected = context.watch<ConnectionProvider>().isConnected;
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage(splashImage),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  Package().info.appName,
                ),
                const SizedBox(height: 4),
                Text(
                  'Version ${Package().info.version}',
                ),
                Text(
                    isConnected
                        ? ''
                        : 'No internet connection',
                )
              ],
            ),
          ),
        )
    );
  }
}
