
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:quick_ass_app/routes/constants.dart';
import 'package:quick_ass_app/screens/screens.dart';
final navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: root,
      builder: (context, state) => RootScreen(),
    ),
    GoRoute(
      path: '/home',
      name: home,
      builder: (context, state) => Home(),
    ),
    GoRoute(
      path: '/onboarding',
      name: onboarding,
      builder: (context, state) => Onboarding(),
    ),
    GoRoute(
      path: '/import-wallet',
      name: importWallet,
      builder: (context, state) => ImportWallet(),
    ),
    GoRoute(
      path: '/change-password',
      name: changePassword,
      builder: (context, state) => ChangePassword(),
    ),
  ],
);