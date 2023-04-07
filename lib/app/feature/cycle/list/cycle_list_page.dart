import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/bloc/authentication_bloc.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/cycle_repository.dart';
import '../addedit/cycle_addedit_page.dart';
import 'bloc/cycle_list_bloc.dart';
import 'bloc/cycle_list_event.dart';
import 'bloc/cycle_list_state.dart';
import 'comp/cycle_card.dart';

class CycleListPage extends StatelessWidget {
  const CycleListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CycleRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return CycleListBloc(
            cycleRepository: RepositoryProvider.of<CycleRepository>(context),
            seller: userProfile,
          );
        },
        child: const CycleListView(),
      ),
    );
  }
}

class CycleListView extends StatelessWidget {
  const CycleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciclos encontrados'),
      ),
      body: BlocListener<CycleListBloc, CycleListState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == CycleListStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == CycleListStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == CycleListStateStatus.loading) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<CycleListBloc, CycleListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<CycleListBloc>()
                                  .add(CycleListEventPreviousPage());
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
                BlocBuilder<CycleListBloc, CycleListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<CycleListBloc>()
                                  .add(CycleListEventNextPage());
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
                child: BlocBuilder<CycleListBloc, CycleListState>(
                  builder: (context, state) {
                    var list = state.cycleModelList;

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return CycleCard(
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<CycleListBloc>(context),
                  child: const CycleAddEditPage(model: null),
                ),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
