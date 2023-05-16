// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'app/core/authentication/bloc/authentication_bloc.dart';
// import 'app/core/models/user_model.dart';
// import 'app/core/repositories/user_repository.dart';
// import 'app/data/b4a/table/user_b4a.dart';
// import 'app/feature/address/save/address_save_page.dart';
// import 'app/feature/address/search/address_search_page.dart';
// import 'app/feature/address/select/address_select_page.dart';
// import 'app/feature/clinic/save/clinic_save_page.dart';
// import 'app/feature/clinic/search/clinic_search_page.dart';
// import 'app/feature/clinic/select/clinic_select_page.dart';
// import 'app/feature/cycle/list/cycle_list_page.dart';
// import 'app/feature/cycle/save/cycle_save_page.dart';
// import 'app/feature/expertise/select/expertise_select_page.dart';
// import 'app/feature/home/home_page.dart';
// import 'app/feature/medical/save/medical_save_page.dart';
// import 'app/feature/medical/search/medical_search_page.dart';
// import 'app/feature/medical/select/medical_select_page.dart';
// import 'app/feature/region/save/region_save_page.dart';
// import 'app/feature/region/search/region_search_page.dart';
// import 'app/feature/region/select/region_select_page.dart';
// import 'app/feature/schedule/save/schedule_save_page.dart';
// import 'app/feature/schedule/search/schedule_search_page.dart';
// import 'app/feature/secretary/save/secretary_save_page.dart';
// import 'app/feature/secretary/search/secretary_search_page.dart';
// import 'app/feature/secretary/select/secretary_select_page.dart';
// import 'app/feature/speed/save/speed_save_page.dart';
// import 'app/feature/splash/splash_page.dart';
// import 'app/feature/user/login/login_page.dart';
// import 'app/feature/user/register/email/user_register_email.page.dart';
// import 'app/feature/userprofile/edit/user_profile_edit_page.dart';
// import 'app/feature/userprofile/search/user_profile_search_page.dart';

// class App extends StatefulWidget {
//   const App({Key? key}) : super(key: key);

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   late final UserRepository _userRepository;

//   @override
//   void initState() {
//     super.initState();
//     _userRepository = UserRepository(userB4a: UserB4a());
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider.value(
//       value: _userRepository,
//       child: BlocProvider(
//         create: (_) => AuthenticationBloc(
//           userRepository: _userRepository,
//         )..add(AuthenticationEventInitial()),
//         child: const AppView(),
//       ),
//     );
//   }
// }

// class AppView extends StatefulWidget {
//   const AppView({Key? key}) : super(key: key);

//   @override
//   State<AppView> createState() => _AppViewState();
// }

// class _AppViewState extends State<AppView> {
//   final _navigatorKey = GlobalKey<NavigatorState>();
//   NavigatorState get _navigator => _navigatorKey.currentState!;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(useMaterial3: true),
//       navigatorKey: _navigatorKey,
//       builder: (context, child) {
//         return BlocListener<AuthenticationBloc, AuthenticationState>(
//           listenWhen: (previous, current) {
//             return previous.status != current.status;
//           },
//           listener: (context, state) {
//             if (state.status == AuthenticationStatus.authenticated) {
//               _navigator.pushAndRemoveUntil<void>(
//                   HomePage.route(), (route) => false);
//             } else if (state.status == AuthenticationStatus.unauthenticated) {
//               _navigator.pushAndRemoveUntil<void>(
//                   LoginPage.route(), (route) => false);
//             } else {
//               return;
//             }
//           },
//           child: child,
//         );
//       },
//       routes: {
//         '/': (_) => const SplashPage(),
//         '/register/email': (_) => const UserRegisterEmailPage(),
//         '/userProfile/edit': (context) {
//           UserModel user =
//               ModalRoute.of(context)!.settings.arguments as UserModel;

//           return UserProfileEditPage(
//             userModel: user,
//           );
//         },
//         '/userProfile/search': (_) => const UserProfileSearchPage(),
//         '/secretary/save': (_) => const SecretarySavePage(),
//         '/secretary/search': (_) => const SecretarySearchPage(),
//         '/secretary/select': (_) => const SecretarySelectPage(),
//         '/medical/save': (_) => const MedicalSavePage(),
//         '/medical/search': (_) => const MedicalSearchPage(),
//         '/medical/select': (_) => const MedicalSelectPage(),
//         '/cycle/save': (_) => const CycleSavePage(),
//         '/cycle/list': (_) => const CycleListPage(),
//         '/region/save': (_) => const RegionSavePage(),
//         '/region/search': (_) => const RegionSearchPage(),
//         '/region/select': (_) => const RegionSelectPage(),
//         '/address/save': (_) => const AddressSavePage(),
//         '/address/search': (_) => const AddressSearchPage(),
//         '/address/select': (_) => const AddressSelectPage(),
//         '/expertise/select': (_) => const ExpertiseSelectPage(),
//         '/clinic/save': (_) => const ClinicSavePage(),
//         '/clinic/search': (_) => const ClinicSearchPage(),
//         '/clinic/select': (_) => const ClinicSelectPage(),
//         '/schedule/save': (_) => const ScheduleSavePage(),
//         '/schedule/search': (_) => const ScheduleSearchPage(),
//         '/speed/save': (_) => const SpeedSavePage(),
//       },
//       initialRoute: '/',
//     );
//   }
// }
