import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/clinic_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/clinic_select_bloc.dart';
import 'bloc/clinic_select_event.dart';
import 'bloc/clinic_select_state.dart';
import 'comp/clinic_card.dart';

class ClinicSelectPage extends StatelessWidget {
  const ClinicSelectPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ClinicRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return ClinicSelectBloc(
            clinicRepository: RepositoryProvider.of<ClinicRepository>(context),
            seller: userProfile,
          );
        },
        child: const ClinicSelectView(),
      ),
    );
  }
}

// class ClinicSelectPage extends StatelessWidget {
//   const ClinicSelectPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const ClinicSelectView();
//   }
// }

class ClinicSelectView extends StatefulWidget {
  const ClinicSelectView({Key? key}) : super(key: key);

  @override
  State<ClinicSelectView> createState() => _ClinicSelectViewState();
}

class _ClinicSelectViewState extends State<ClinicSelectView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTEC = TextEditingController();

  @override
  void initState() {
    _nameTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione um endereço'),
      ),
      body: BlocListener<ClinicSelectBloc, ClinicSelectState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ClinicSelectStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ClinicSelectStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == ClinicSelectStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  AppTextFormField(
                    label: 'Nome',
                    controller: _nameTEC,
                    onChange: (value) {
                      context
                          .read<ClinicSelectBloc>()
                          .add(ClinicSelectEventFormSubmitted(value));
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<ClinicSelectBloc, ClinicSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<ClinicSelectBloc>()
                                  .add(ClinicSelectEventPreviousPage());
                            },
                      child: Card(
                        color: state.firstPage ? Colors.black : Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: state.firstPage
                                ? const Text('Primeira página')
                                : const Text('Página anterior'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<ClinicSelectBloc, ClinicSelectState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<ClinicSelectBloc>()
                                  .add(ClinicSelectEventNextPage());
                            },
                      child: Card(
                        color: state.lastPage ? Colors.black : Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: state.lastPage
                                ? const Text('Última página')
                                : const Text('Próxima página'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: BlocBuilder<ClinicSelectBloc, ClinicSelectState>(
                  builder: (context, state) {
                    var list = state.listFiltered;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return ClinicCard(
                          model: item,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
