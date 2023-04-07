import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/address_search_bloc.dart';
import '../bloc/address_search_event.dart';
import '../bloc/address_search_state.dart';
import 'comp/address_card.dart';

class AddressSearchListPage extends StatelessWidget {
  const AddressSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AddressSearchListView();
  }
}

class AddressSearchListView extends StatelessWidget {
  const AddressSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Endereços encontrados'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BlocBuilder<AddressSearchBloc, AddressSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.firstPage
                        ? null
                        : () {
                            context
                                .read<AddressSearchBloc>()
                                .add(AddressSearchEventPreviousPage());
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
              BlocBuilder<AddressSearchBloc, AddressSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.lastPage
                        ? null
                        : () {
                            context
                                .read<AddressSearchBloc>()
                                .add(AddressSearchEventNextPage());
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
              child: BlocBuilder<AddressSearchBloc, AddressSearchState>(
                builder: (context, state) {
                  var list = state.list;

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return AddressCard(
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
    );
  }
}
