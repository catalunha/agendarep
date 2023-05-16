import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/secretary_model.dart';
import '../../utils/app_text_title_value.dart';

class SecretaryViewPage extends StatelessWidget {
  final SecretaryModel model;
  SecretaryViewPage({super.key, required this.model});
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
                  value: model.id,
                ),
                AppTextTitleValue(
                  title: 'Rep: ',
                  value: model.seller?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Email: ',
                  value: model.email,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Nome: ',
                  value: model.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Telefone: ',
                  value: model.phone,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Aniversário: ',
                  value: model.birthday == null
                      ? '...'
                      : dateFormat.format(model.birthday!),
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
