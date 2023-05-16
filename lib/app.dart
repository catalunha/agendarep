import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app/core/authentication/bloc/authentication_bloc.dart';
import 'app/core/repositories/user_repository.dart';
import 'app/data/b4a/table/user_b4a.dart';
import 'app/feature/home/home_page.dart';
import 'app/feature/splash/splash_page.dart';
import 'app/feature/user/login/login_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserB4a(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(
            userB4a: RepositoryProvider.of<UserB4a>(context),
          ),
        )
      ],
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => AuthenticationBloc(
              userRepository: RepositoryProvider.of<UserRepository>(context),
            )..add(AuthenticationEventInitial()),
            child: const AppView(),
          );
        },
      ),
    );
  }
}

// class App2 extends StatelessWidget {
//   const App2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => AuthenticationBloc(
//         userRepository: RepositoryProvider.of<UserRepository>(context),
//       )..add(AuthenticationEventInitial()),
//       child: const AppView(),
//     );
//   }
// }

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // routeInformationProvider: goRouter.routeInformationProvider,
      // routeInformationParser: goRouter.routeInformationParser,
      // routerDelegate: goRouter.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      routerConfig: goRouter,
    );
  }

  // static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter goRouter = GoRouter(
    // navigatorKey: _rootNavigatorKey,

    debugLogDiagnostics: true,
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
    // refreshListenable: context.read<AuthenticationBloc>(),
  );

  String? _obsLogged(BuildContext context, GoRouterState state) {
    String path = '/';
    final AuthenticationStatus statusLoggin =
        context.read<AuthenticationBloc>().state.status;
    log('Status inicial: ');
    if (statusLoggin == AuthenticationStatus.authenticated) {
      path = '/home';
    } else if (statusLoggin == AuthenticationStatus.unauthenticated) {
      path = '/login';
    } else {
      path = '/';
    }

    return path;
  }
}
