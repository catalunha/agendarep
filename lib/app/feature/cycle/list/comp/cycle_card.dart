import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/cycle_model.dart';
import '../../../../routes.dart';
import '../../../utils/app_text_title_value.dart';
import '../../save/cycle_save_page.dart';
import '../bloc/cycle_list_bloc.dart';

class CycleCard extends StatelessWidget {
  final CycleModel model;
  const CycleCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');

    return Card(
      child: Column(
        children: [
          AppTextTitleValue(
            title: 'Id: ',
            value: model.id,
          ),
          AppTextTitleValue(
            title: 'Cadastrada pelo Representante: ',
            value: model.seller?.name,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: model.name,
          ),
          AppTextTitleValue(
            title: 'Arquivado: ',
            value: model.isArchived ?? true ? 'Sim' : 'Não',
            inColumn: true,
          ),
          AppTextTitleValue(
            title: 'Inicio: ',
            value: dateFormat.format(model.start!),
          ),
          AppTextTitleValue(
            title: 'Fim: ',
            value: dateFormat.format(model.end!),
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<CycleListBloc>(context),
                        child: CycleSavePage(model: model),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => CycleViewPage(model: model),
                  //   ),
                  // );
                  context.pushNamed(
                    AppPage.cycleView.name,
                    extra: model,
                  );
                },
                icon: const Icon(
                  Icons.assignment_ind_outlined,
                ),
              ),
              // IconButton(
              //   onPressed: () => copy(model.id!),
              //   icon: const Icon(
              //     Icons.copy,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
