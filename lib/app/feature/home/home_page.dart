import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/authentication/bloc/authentication_bloc.dart';
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
                "Olá, ${state.user?.userProfile?.name ?? 'Atualize seu perfil.'}.");
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
                      Navigator.of(context).pushNamed('/region/save');
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/region/search');
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
                      Navigator.of(context).pushNamed('/address/save');
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/address/search');
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
                      Navigator.of(context).pushNamed('/secretary/save');
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/secretary/search');
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
                      Navigator.of(context).pushNamed('/medical/save');
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/medical/search');
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Consultorio',
                access: const ['seller'],
                onAction: () {
                  Navigator.of(context).pushNamed('/clinic/save');
                },
                icon: Icons.house,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/clinic/save');
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/clinic/search');
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Ciclos',
                access: const ['seller'],
                onAction: () {
                  Navigator.of(context).pushNamed('/cycle/list');
                },
                icon: Icons.cyclone_sharp,
                color: Colors.black87,
              ),
              HomeCardModule(
                title: 'Especialidades',
                access: const ['seller'],
                onAction: () {
                  Navigator.of(context).pushNamed('/expertise/select');
                },
                icon: Icons.list,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
