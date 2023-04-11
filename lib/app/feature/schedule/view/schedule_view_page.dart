import 'package:flutter/material.dart';

import '../../../core/models/schedule_models.dart';
import '../../utils/app_text_title_value.dart';

class ScheduleViewPage extends StatelessWidget {
  final ScheduleModel model;
  const ScheduleViewPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados desta agenda')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextTitleValue(
                  title: 'Id: ',
                  value: model.id,
                ),
                AppTextTitleValue(
                  title: 'Rep: ',
                  value: model.seller?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Medico: ',
                  value: model.medical?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Especialidade: ',
                  value: model.expertise?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Consultório: ',
                  value: model.clinic?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Atendimento tipo: ',
                  value: model.justSchedule ?? false ? 'Agendado' : 'Semanal',
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Limite de representantes: ',
                  value: model.limitedSellers?.toString(),
                ),
                AppTextTitleValue(
                  title: 'Segunda-feira: ',
                  value: model.mondayHours
                      ?.map((e) => e.toString())
                      .toList()
                      .join(', '),
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
                  value: model.fridayHours
                      ?.map((e) => e.toString())
                      .toList()
                      .join(', '),
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
                  value: model.sundayHours
                      ?.map((e) => e.toString())
                      .toList()
                      .join(', '),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
