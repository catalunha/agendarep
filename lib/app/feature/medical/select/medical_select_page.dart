import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/medical_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/medical_select_bloc.dart';
import 'bloc/medical_select_event.dart';
import 'bloc/medical_select_state.dart';
import 'comp/medical_card.dart';

class MedicalSelectPage extends StatelessWidget {
  const MedicalSelectPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MedicalRepository(),
      child: BlocProvider(
        create: (context) {
          final UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return MedicalSelectBloc(
            medicalRepository:
                RepositoryProvider.of<MedicalRepository>(context),
            seller: userProfile,
          );
        },
        child: const MedicalSelectView(),
      ),
    );
  }
}

// class MedicalSelectPage extends StatelessWidget {
//   const MedicalSelectPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MedicalSelectView();
//   }
// }

class MedicalSelectView extends StatefulWidget {
  const MedicalSelectView({Key? key}) : super(key: key);

  @override
  State<MedicalSelectView> createState() => _MedicalSelectViewState();
}

class _MedicalSelectViewState extends State<MedicalSelectView> {
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
        title: const Text('Selecione um médico'),
      ),
      body: BlocListener<MedicalSelectBloc, MedicalSelectState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == MedicalSelectStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == MedicalSelectStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == MedicalSelectStateStatus.loading) {
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
              child: Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      label: 'Nome',
                      controller: _nameTEC,
                      onChange: (value) {
                        context
                            .read<MedicalSelectBloc>()
                            .add(MedicalSelectEventFormSubmitted(value));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<MedicalSelectBloc>()
                          .add(MedicalSelectEventFormSubmitted(_nameTEC.text));
                    },
                    icon: const Icon(Icons.youtube_searched_for_sharp),
                  )
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     BlocBuilder<MedicalSelectBloc, MedicalSelectState>(
            //       builder: (context, state) {
            //         return InkWell(
            //           onTap: state.firstPage
            //               ? null
            //               : () {
            //                   context
            //                       .read<MedicalSelectBloc>()
            //                       .add(MedicalSelectEventPreviousPage());
            //                 },
            //           child: Card(
            //             color: state.firstPage ? Colors.black : Colors.black45,
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Center(
            //                 child: state.firstPage
            //                     ? const Text('Primeira página')
            //                     : const Text('Página anterior'),
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //     BlocBuilder<MedicalSelectBloc, MedicalSelectState>(
            //       builder: (context, state) {
            //         return InkWell(
            //           onTap: state.lastPage
            //               ? null
            //               : () {
            //                   context
            //                       .read<MedicalSelectBloc>()
            //                       .add(MedicalSelectEventNextPage());
            //                 },
            //           child: Card(
            //             color: state.lastPage ? Colors.black : Colors.black45,
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Center(
            //                 child: state.lastPage
            //                     ? const Text('Última página')
            //                     : const Text('Próxima página'),
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ],
            // ),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: BlocBuilder<MedicalSelectBloc, MedicalSelectState>(
                  builder: (context, state) {
                    final list = state.listFiltered;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return MedicalCard(
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
