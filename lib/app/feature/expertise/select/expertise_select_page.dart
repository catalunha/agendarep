import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/expertise_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/expertise_select_bloc.dart';
import 'bloc/expertise_select_event.dart';
import 'bloc/expertise_select_state.dart';
import 'comp/expertise_card.dart';

class ExpertiseSelectPage extends StatelessWidget {
  const ExpertiseSelectPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ExpertiseRepository(),
      child: BlocProvider(
        create: (context) {
          final UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return ExpertiseSelectBloc(
            expertiseRepository:
                RepositoryProvider.of<ExpertiseRepository>(context),
            seller: userProfile,
          );
        },
        child: const ExpertiseSelectView(),
      ),
    );
  }
}

// class ExpertiseSelectPage extends StatelessWidget {
//   const ExpertiseSelectPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const ExpertiseSelectView();
//   }
// }

class ExpertiseSelectView extends StatefulWidget {
  const ExpertiseSelectView({Key? key}) : super(key: key);

  @override
  State<ExpertiseSelectView> createState() => _ExpertiseSelectViewState();
}

class _ExpertiseSelectViewState extends State<ExpertiseSelectView> {
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
        title: const Text('Selecione uma especialidade'),
      ),
      body: BlocListener<ExpertiseSelectBloc, ExpertiseSelectState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ExpertiseSelectStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ExpertiseSelectStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == ExpertiseSelectStateStatus.loading) {
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
                      label: 'Nome da especialidade',
                      controller: _nameTEC,
                      onChange: (value) {
                        context
                            .read<ExpertiseSelectBloc>()
                            .add(ExpertiseSelectEventFormSubmitted(value));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<ExpertiseSelectBloc>().add(
                          ExpertiseSelectEventFormSubmitted(_nameTEC.text));
                    },
                    icon: const Icon(Icons.youtube_searched_for_sharp),
                  )
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     BlocBuilder<ExpertiseSelectBloc, ExpertiseSelectState>(
            //       builder: (context, state) {
            //         return InkWell(
            //           onTap: state.firstPage
            //               ? null
            //               : () {
            //                   context
            //                       .read<ExpertiseSelectBloc>()
            //                       .add(ExpertiseSelectEventPreviousPage());
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
            //     BlocBuilder<ExpertiseSelectBloc, ExpertiseSelectState>(
            //       builder: (context, state) {
            //         return InkWell(
            //           onTap: state.lastPage
            //               ? null
            //               : () {
            //                   context
            //                       .read<ExpertiseSelectBloc>()
            //                       .add(ExpertiseSelectEventNextPage());
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
                child: BlocBuilder<ExpertiseSelectBloc, ExpertiseSelectState>(
                  builder: (context, state) {
                    final list = state.listFiltered;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return ExpertiseCard(
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
