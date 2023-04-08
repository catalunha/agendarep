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
                  title: 'Consultorio: ',
                  value: model.clinic?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Atende agendado: ',
                  value: model.justSchedule ?? false ? "Sim" : "Não",
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Limite de representante: ',
                  value: model.limitedSellers?.toString(),
                ),
                AppTextTitleValue(
                  title: 'Dia da semana: ',
                  value: model.weekday?.toString(),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Secretárias: ',
                  value: model.hour?.map((e) => e).toList().join(', '),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
