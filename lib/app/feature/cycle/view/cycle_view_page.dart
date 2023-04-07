import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/cycle_model.dart';
import '../../utils/app_text_title_value.dart';

class CycleViewPage extends StatelessWidget {
  final CycleModel model;
  CycleViewPage({super.key, required this.model});
  final dateFormat = DateFormat('dd/MM/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados deste médico')),
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
                  title: 'Nome: ',
                  value: model.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Bloqueado: ',
                  value:
                      model.isArchived ?? false ? 'Bloqueado' : 'Desbloqueado',
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Inicio: ',
                  value: model.start == null
                      ? '...'
                      : dateFormat.format(model.start!),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Fim: ',
                  value:
                      model.end == null ? '...' : dateFormat.format(model.end!),
                  inColumn: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
