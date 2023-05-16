import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/authentication/bloc/authentication_bloc.dart';
import '../../routes.dart';
import 'comp/home_card_module.dart';
import 'comp/home_popmenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Text(
              "Olá, ${state.user?.userProfile?.name ?? 'Atualize seu perfil.'}.",
            );
          },
        ),
        actions: const [
          HomePopMenu(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              HomeCardModule(
                title: 'Usuários',
                access: const ['admin'],
                onAction: () {
                  Navigator.of(context).pushNamed('/userProfile/search');
                },
                icon: Icons.people,
                color: Colors.black,
              ),
              HomeCardModule(
                title: 'Regiões',
                access: const ['seller'],
                icon: Icons.bubble_chart_outlined,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/region/save');
                      context.goNamed(AppPage.regionSave.name);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/region/search');
                      // context.go('/home/region/search');
                      context.goNamed(AppPage.regionSearch.name);
                      // context.pushNamed(AppPage.regionSearch.name);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Endereço',
                access: const ['seller'],
                icon: Icons.location_city,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/address/save');
                      // context.go('/home/address/save');
                      context.goNamed(AppPage.addressSave.name);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/address/search');
                      // context.go('/home/address/search');
                      context.goNamed(AppPage.addressSearch.name);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Secretária',
                access: const ['seller'],
                icon: Icons.person_2_outlined,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/secretary/save');
                      context.goNamed(AppPage.secretarySave.name);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/secretary/search');
                      context.goNamed(AppPage.secretarySearch.name);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Médico',
                access: const ['seller'],
                icon: Icons.medical_information,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/medical/save');
                      context.goNamed(AppPage.medicalSave.name);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/medical/search');
                      context.goNamed(AppPage.medicalSearch.name);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Consultorio',
                access: const ['seller'],
                icon: Icons.house,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/clinic/save');
                      context.goNamed(AppPage.clinicSave.name);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/clinic/search');
                      context.goNamed(AppPage.clinicSearch.name);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Agenda do médico',
                access: const ['seller'],
                icon: Icons.schedule,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/schedule/save');
                      context.goNamed(AppPage.scheduleSave.name);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/schedule/search');
                      context.goNamed(AppPage.scheduleSearch.name);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Ciclos',
                access: const ['seller'],
                onAction: () {
                  // Navigator.of(context).pushNamed('/cycle/list');
                  context.goNamed(AppPage.cycleList.name);
                },
                icon: Icons.cyclone_sharp,
                color: Colors.black87,
              ),
              HomeCardModule(
                title: 'Especialidades',
                access: const ['seller'],
                onAction: () {
                  // Navigator.of(context).pushNamed('/expertise/select');
                  context.goNamed(AppPage.expertiseSelect.name);
                },
                icon: Icons.list,
                color: Colors.black87,
              ),
              // HomeCardModule(
              //   title: 'Cadastro rápido',
              //   access: const ['seller'],
              //   onAction: () {
              //     Navigator.of(context).pushNamed('/speed/save');
              //   },
              //   icon: Icons.speed,
              //   color: Colors.black87,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
