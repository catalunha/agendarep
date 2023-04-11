import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/clinic_model.dart';
import '../../utils/app_text_title_value.dart';

class ClinicViewPage extends StatelessWidget {
  final ClinicModel model;
  ClinicViewPage({super.key, required this.model});
  final dateFormat = DateFormat('dd/MM/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados deste consultório')),
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
                ),
                AppTextTitleValue(
                  title: 'Medico: ',
                  value: model.medical?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Endereço: ',
                  value: model.address?.description,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Região: ',
                  value: model.address?.region?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Secretárias: ',
                  value:
                      model.secretaries?.map((e) => e.name).toList().join(', '),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Nome: ',
                  value: model.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Sala: ',
                  value: model.room,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Telefone: ',
                  value: model.phone,
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
