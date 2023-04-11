import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/medical_model.dart';
import '../../utils/app_text_title_value.dart';

class MedicalViewPage extends StatelessWidget {
  final MedicalModel medicalModel;
  MedicalViewPage({super.key, required this.medicalModel});
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
                  value: medicalModel.id,
                ),
                AppTextTitleValue(
                  title: 'Rep: ',
                  value: medicalModel.seller?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Email: ',
                  value: medicalModel.email,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Nome: ',
                  value: medicalModel.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Telefone: ',
                  value: medicalModel.phone,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'CRM: ',
                  value: medicalModel.crm,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Bloqueado: ',
                  value: medicalModel.isBlocked ?? false
                      ? 'Bloqueado'
                      : 'Desbloqueado',
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Aniversário: ',
                  value: medicalModel.birthday == null
                      ? '...'
                      : dateFormat.format(medicalModel.birthday!),
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Especialidades: ',
                  value: medicalModel.expertises
                      ?.map((e) => e.name)
                      .toList()
                      .join(', '),
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
