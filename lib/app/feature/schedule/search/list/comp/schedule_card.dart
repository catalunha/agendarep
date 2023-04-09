import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/schedule_models.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/schedule_save_page.dart';
import '../../../view/schedule_view_page.dart';
import '../../bloc/schedule_search_bloc.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleModel model;
  const ScheduleCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title: 'Medico: ',
            value: model.medical?.name,
          ),
          AppTextTitleValue(
            title: 'Especialidade: ',
            value: model.expertise?.name,
          ),
          AppTextTitleValue(
            title: 'Consultório: ',
            value: model.clinic?.name,
          ),
          AppTextTitleValue(
            title: 'Limite de representantes: ',
            value: model.limitedSellers?.toString(),
          ),
          AppTextTitleValue(
            title: 'Atendimento tipo: ',
            value: model.justSchedule ?? false ? 'Agendado' : 'Semanal',
          ),
          AppTextTitleValue(
            title: 'Segunda-feira: ',
            value:
                model.mondayHours?.map((e) => e.toString()).toList().join(', '),
          ),
          AppTextTitleValue(
            title: 'Terça-feira: ',
            value: model.tuesdayHours
                ?.map((e) => e.toString())
                .toList()
                .join(', '),
          ),
          AppTextTitleValue(
            title: 'Quarta-feira: ',
            value: model.wednesdayHours
                ?.map((e) => e.toString())
                .toList()
                .join(', '),
          ),
          AppTextTitleValue(
            title: 'Quinta-feira: ',
            value: model.thursdayHours
                ?.map((e) => e.toString())
                .toList()
                .join(', '),
          ),
          AppTextTitleValue(
            title: 'Sexta-feira: ',
            value:
                model.fridayHours?.map((e) => e.toString()).toList().join(', '),
          ),
          AppTextTitleValue(
            title: 'Sabado: ',
            value: model.saturdayHours
                ?.map((e) => e.toString())
                .toList()
                .join(', '),
          ),
          AppTextTitleValue(
            title: 'Domingo: ',
            value:
                model.sundayHours?.map((e) => e.toString()).toList().join(', '),
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ScheduleSearchBloc>(context),
                        child: ScheduleSavePage(model: model),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ScheduleViewPage(model: model),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.assignment_ind_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
