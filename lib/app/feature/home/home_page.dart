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
                title: 'Gerenciar usuários',
                access: const ['admin'],
                onAction: () {
                  Navigator.of(context).pushNamed('/userProfile/search');
                },
                icon: Icons.people,
                color: Colors.black87,
              ),
              HomeCardModule(
                title: 'Adicionar Secretária',
                access: const ['representante'],
                onAction: () {
                  Navigator.of(context).pushNamed('/secretary/addedit');
                },
                icon: Icons.person_2_outlined,
                color: Colors.black87,
              ),
              HomeCardModule(
                title: 'Buscar Secretária',
                access: const ['representante'],
                onAction: () {
                  Navigator.of(context).pushNamed('/secretary/search');
                },
                icon: Icons.search,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
