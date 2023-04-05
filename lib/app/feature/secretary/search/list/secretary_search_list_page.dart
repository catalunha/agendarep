import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/secretary_search_bloc.dart';
import '../bloc/secretary_search_event.dart';
import '../bloc/secretary_search_state.dart';
import 'comp/secretary_list.dart';

class SecretarySearchListPage extends StatelessWidget {
  const SecretarySearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SecretarySearchListView();
  }
}

class SecretarySearchListView extends StatelessWidget {
  const SecretarySearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secretárias encontradas'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BlocBuilder<SecretarySearchBloc, SecretarySearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.firstPage
                        ? null
                        : () {
                            context
                                .read<SecretarySearchBloc>()
                                .add(SecretarySearchEventPreviousPage());
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
              BlocBuilder<SecretarySearchBloc, SecretarySearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.lastPage
                        ? null
                        : () {
                            context
                                .read<SecretarySearchBloc>()
                                .add(SecretarySearchEventNextPage());
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
              child: BlocBuilder<SecretarySearchBloc, SecretarySearchState>(
                builder: (context, state) {
                  return SecretaryList(
                    cautionList: state.secretaryModelList,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
