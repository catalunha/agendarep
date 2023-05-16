import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app/core/authentication/bloc/authentication_bloc.dart';
import 'app/core/models/address_model.dart';
import 'app/core/models/medical_model.dart';
import 'app/core/models/region_model.dart';
import 'app/core/models/secretary_model.dart';
import 'app/core/repositories/user_repository.dart';
import 'app/data/b4a/table/user_b4a.dart';
import 'app/feature/address/save/address_save_page.dart';
import 'app/feature/address/search/address_search_page.dart';
import 'app/feature/address/search/bloc/address_search_bloc.dart';
import 'app/feature/address/search/list/address_search_list_page.dart';
import 'app/feature/address/select/address_select_page.dart';
import 'app/feature/address/view/address_view_page.dart';
import 'app/feature/home/home_page.dart';
import 'app/feature/medical/save/medical_save_page.dart';
import 'app/feature/medical/search/bloc/medical_search_bloc.dart';
import 'app/feature/medical/search/list/medical_search_list_page.dart';
import 'app/feature/medical/search/medical_search_page.dart';
import 'app/feature/medical/select/medical_select_page.dart';
import 'app/feature/medical/view/medical_view_page.dart';
import 'app/feature/region/save/region_save_page.dart';
import 'app/feature/region/search/bloc/region_search_bloc.dart';
import 'app/feature/region/search/list/region_search_list_page.dart';
import 'app/feature/region/search/region_search_page.dart';
import 'app/feature/region/select/region_select_page.dart';
import 'app/feature/region/view/region_view_page.dart';
import 'app/feature/secretary/save/secretary_save_page.dart';
import 'app/feature/secretary/search/bloc/secretary_search_bloc.dart';
import 'app/feature/secretary/search/list/secretary_search_list_page.dart';
import 'app/feature/secretary/search/secretary_search_page.dart';
import 'app/feature/secretary/select/secretary_select_page.dart';
import 'app/feature/secretary/view/secretary_view_page.dart';
import 'app/feature/splash/splash_page.dart';
import 'app/feature/user/login/login_page.dart';
import 'app/routes.dart';

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
        path: AppPage.splash.path,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppPage.login.path,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppPage.home.path,
        builder: (context, state) => const HomePage(),
        routes: [
          //Region
          GoRoute(
            name: AppPage.regionSave.name,
            path: AppPage.regionSave.path,
            builder: (context, state) => const RegionSavePage(),
          ),
          GoRoute(
            name: AppPage.regionSearch.name,
            path: AppPage.regionSearch.path,
            builder: (context, state) => const RegionSearchPage(),
            routes: [
              GoRoute(
                name: AppPage.regionSearchList.name,
                path: AppPage.regionSearchList.path,
                builder: (context, state) {
                  return BlocProvider.value(
                    value: BlocProvider.of<RegionSearchBloc>(
                      state.extra as BuildContext,
                    ),
                    child: const RegionSearchListPage(),
                  );
                },
              ),
              GoRoute(
                name: AppPage.regionView.name,
                path: AppPage.regionView.path,
                builder: (context, state) {
                  return RegionViewPage(model: state.extra! as RegionModel);
                },
              ),
              GoRoute(
                name: AppPage.regionSelect.name,
                path: AppPage.regionSelect.path,
                builder: (context, state) => const RegionSelectPage(),
              ),
            ],
          ),
          //Address
          GoRoute(
            name: AppPage.addressSave.name,
            path: AppPage.addressSave.path,
            builder: (context, state) => const AddressSavePage(),
          ),
          GoRoute(
            name: AppPage.addressSearch.name,
            path: AppPage.addressSearch.path,
            builder: (context, state) => const AddressSearchPage(),
            routes: [
              GoRoute(
                name: AppPage.addressSearchList.name,
                path: AppPage.addressSearchList.path,
                builder: (context, state) {
                  return BlocProvider.value(
                    value: BlocProvider.of<AddressSearchBloc>(
                      state.extra as BuildContext,
                    ),
                    child: const AddressSearchListPage(),
                  );
                },
              ),
              GoRoute(
                name: AppPage.addressView.name,
                path: AppPage.addressView.path,
                builder: (context, state) {
                  return AddressViewPage(model: state.extra! as AddressModel);
                },
              ),
              GoRoute(
                name: AppPage.addressSelect.name,
                path: AppPage.addressSelect.path,
                builder: (context, state) => const AddressSelectPage(),
              ),
            ],
          ),
          //Secretary
          GoRoute(
            name: AppPage.secretarySave.name,
            path: AppPage.secretarySave.path,
            builder: (context, state) => const SecretarySavePage(),
          ),
          GoRoute(
            name: AppPage.secretarySearch.name,
            path: AppPage.secretarySearch.path,
            builder: (context, state) => const SecretarySearchPage(),
            routes: [
              GoRoute(
                name: AppPage.secretarySearchList.name,
                path: AppPage.secretarySearchList.path,
                builder: (context, state) {
                  return BlocProvider.value(
                    value: BlocProvider.of<SecretarySearchBloc>(
                      state.extra as BuildContext,
                    ),
                    child: const SecretarySearchListPage(),
                  );
                },
              ),
              GoRoute(
                name: AppPage.secretaryView.name,
                path: AppPage.secretaryView.path,
                builder: (context, state) {
                  return SecretaryViewPage(
                      model: state.extra! as SecretaryModel);
                },
              ),
              GoRoute(
                name: AppPage.secretarySelect.name,
                path: AppPage.secretarySelect.path,
                builder: (context, state) => const SecretarySelectPage(),
              ),
            ],
          ),
          //Medical
          GoRoute(
            name: AppPage.medicalSave.name,
            path: AppPage.medicalSave.path,
            builder: (context, state) => const MedicalSavePage(),
          ),
          GoRoute(
            name: AppPage.medicalSearch.name,
            path: AppPage.medicalSearch.path,
            builder: (context, state) => const MedicalSearchPage(),
            routes: [
              GoRoute(
                name: AppPage.medicalSearchList.name,
                path: AppPage.medicalSearchList.path,
                builder: (context, state) {
                  return BlocProvider.value(
                    value: BlocProvider.of<MedicalSearchBloc>(
                      state.extra as BuildContext,
                    ),
                    child: const MedicalSearchListPage(),
                  );
                },
              ),
              GoRoute(
                name: AppPage.medicalView.name,
                path: AppPage.medicalView.path,
                builder: (context, state) {
                  return MedicalViewPage(model: state.extra! as MedicalModel);
                },
              ),
              GoRoute(
                name: AppPage.medicalSelect.name,
                path: AppPage.medicalSelect.path,
                builder: (context, state) => const MedicalSelectPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    initialLocation: '/',
    redirect: _obsLogged,
    refreshListenable: context.read<AuthenticationBloc>(),
  );

  String? _obsLogged(BuildContext context, GoRouterState state) {
    final AuthenticationStatus statusLoggin =
        context.read<AuthenticationBloc>().state.status;
    log('+++ _obsLogged');
    log('state.fullPath: ${state.fullPath}');
    log('state.location: ${state.location}');
    log('state.matchedLocation: ${state.matchedLocation}');
    log('state.name: ${state.name}');
    log('state.path: ${state.path}');

    if (statusLoggin == AuthenticationStatus.unauthenticated) {
      return '/login';
    }
    if (statusLoggin == AuthenticationStatus.authenticated &&
        (state.matchedLocation == '/login' || state.matchedLocation == '/')) {
      return '/home';
    }
    return null;
  }
}
