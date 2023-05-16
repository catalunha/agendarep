import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/authentication/authentication.dart';
import 'feature/home/home_page.dart';
import 'feature/splash/splash_page.dart';
import 'feature/user/login/login_page.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
  initialLocation: '/',
  redirect: _obsLogged,
  // refreshListenable: context.read<AuthenticationBloc>()
);

String? _obsLogged(BuildContext context, GoRouterState state) {
  String path = '/';
  final AuthenticationStatus statusLoggin =
      context.read<AuthenticationBloc>().state.status;

  if (statusLoggin == AuthenticationStatus.authenticated) {
    path = '/home';
  } else if (statusLoggin == AuthenticationStatus.unauthenticated) {
    path = '/login';
  } else {
    path = '/';
  }

  return path;
}

// class AuthStateNotifier extends ChangeNotifier {
//   late final StreamSubscription<AuthenticationBloc> _blocStream;
//   AuthStateProvider(AuthenticationBloc bloc) {
//     _blocStream = bloc.stream.listen((event) {
//       notifyListeners();
//     });
//   }

//   @override
//   void dispose() {
//     _blocStream.cancel();
//     super.dispose();
//   }
// }
