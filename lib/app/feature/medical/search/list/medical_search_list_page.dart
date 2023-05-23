import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/medical_search_bloc.dart';
import '../bloc/medical_search_event.dart';
import '../bloc/medical_search_state.dart';
import 'comp/medical_card.dart';

class MedicalSearchListPage extends StatelessWidget {
  const MedicalSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MedicalSearchListView();
  }
}

class MedicalSearchListView extends StatelessWidget {
  const MedicalSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Médicos encontrados'),
      ),
      body: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     BlocBuilder<MedicalSearchBloc, MedicalSearchState>(
          //       builder: (context, state) {
          //         return InkWell(
          //           onTap: state.firstPage
          //               ? null
          //               : () {
          //                   context
          //                       .read<MedicalSearchBloc>()
          //                       .add(MedicalSearchEventPreviousPage());
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
          //     BlocBuilder<MedicalSearchBloc, MedicalSearchState>(
          //       builder: (context, state) {
          //         return InkWell(
          //           onTap: state.lastPage
          //               ? null
          //               : () {
          //                   context
          //                       .read<MedicalSearchBloc>()
          //                       .add(MedicalSearchEventNextPage());
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
              child: BlocBuilder<MedicalSearchBloc, MedicalSearchState>(
                builder: (context, state) {
                  final list = state.medicalModelList;
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
    );
  }
}
