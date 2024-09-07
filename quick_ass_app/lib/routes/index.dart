
import 'package:go_router/go_router.dart';

import 'package:quick_ass_app/routes/constants.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: root,
      // builder: (context, state) => RootScreen(),
    ),
    GoRoute(
      path: '/home',
      name: home,
      // builder: (context, state) => Home(),
    ),
    GoRoute(
      path: '/onboarding',
      name: onboarding,
      // builder: (context, state) => Onboarding(),
    ),
    GoRoute(
      path: '/import-wallet',
      name: importWallet,
      // builder: (context, state) => ImportWallet(),
    ),
    GoRoute(
      path: '/change-password',
      name: changePassword,
      // builder: (context, state) => ChangePassword(),
    ),
  ],
);