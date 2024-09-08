import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/constants/image_uri.dart';
import 'package:quick_ass_app/services/package.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';

class Splash extends StatelessWidget {
  const Splash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  'Package().info.appName'
                  // Package().info.appName,
                ),
                const SizedBox(height: 4),
                Text(
                  'Version'
                  // 'Version ${Package().info.version}',
                ),
              ],
            ),
          ),
        )
    );
  }
}
