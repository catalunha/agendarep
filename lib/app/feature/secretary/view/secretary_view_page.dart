import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/secretary_model.dart';
import '../../utils/app_text_title_value.dart';

class SecretaryViewPage extends StatelessWidget {
  final SecretaryModel secretaryModel;
  SecretaryViewPage({super.key, required this.secretaryModel});
  final dateFormat = DateFormat('dd/MM/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados desta secretaria')),
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
                  value: secretaryModel.id,
                ),
                AppTextTitleValue(
                  title: 'Email: ',
                  value: secretaryModel.email,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Nome: ',
                  value: secretaryModel.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Telefone: ',
                  value: secretaryModel.phone,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Aniversário: ',
                  value: secretaryModel.birthday == null
                      ? '...'
                      : dateFormat.format(secretaryModel.birthday!),
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
