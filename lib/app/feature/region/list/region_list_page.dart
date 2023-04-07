import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/bloc/authentication_bloc.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/region_repository.dart';
import '../save/region_save_page.dart';
import 'bloc/region_list_bloc.dart';
import 'bloc/region_list_event.dart';
import 'bloc/region_list_state.dart';
import 'comp/region_card.dart';

class RegionListPage extends StatelessWidget {
  const RegionListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RegionRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return RegionListBloc(
            regionRepository: RepositoryProvider.of<RegionRepository>(context),
            seller: userProfile,
          );
        },
        child: const RegionListView(),
      ),
    );
  }
}

class RegionListView extends StatelessWidget {
  const RegionListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regiões encontradas'),
      ),
      body: BlocListener<RegionListBloc, RegionListState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == RegionListStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == RegionListStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == RegionListStateStatus.loading) {
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
                BlocBuilder<RegionListBloc, RegionListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.firstPage
                          ? null
                          : () {
                              context
                                  .read<RegionListBloc>()
                                  .add(RegionListEventPreviousPage());
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
                BlocBuilder<RegionListBloc, RegionListState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: state.lastPage
                          ? null
                          : () {
                              context
                                  .read<RegionListBloc>()
                                  .add(RegionListEventNextPage());
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
                child: BlocBuilder<RegionListBloc, RegionListState>(
                  builder: (context, state) {
                    var list = state.list;

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return RegionCard(
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
                  value: BlocProvider.of<RegionListBloc>(context),
                  child: const RegionSavePage(model: null),
                ),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
