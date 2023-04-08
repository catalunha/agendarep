import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/secretary_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/secretary_save_page.dart';
import '../../../view/secretary_view_page.dart';
import '../../bloc/secretary_search_bloc.dart';

class SecretaryCard extends StatelessWidget {
  final SecretaryModel secretaryModel;
  const SecretaryCard({Key? key, required this.secretaryModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');

    return Card(
      child: Column(
        children: [
          AppTextTitleValue(
            title: 'Id: ',
            value: secretaryModel.id,
          ),
          AppTextTitleValue(
            title: 'Cadastrada pelo Representante: ',
            value: secretaryModel.seller?.name,
          ),
          AppTextTitleValue(
            title: 'Email: ',
            value: secretaryModel.email,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: secretaryModel.name,
          ),
          AppTextTitleValue(
            title: 'Telefone: ',
            value: secretaryModel.phone,
          ),
          AppTextTitleValue(
            title: 'Data de Aniversário: ',
            value: dateFormat.format(secretaryModel.birthday!),
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<SecretarySearchBloc>(context),
                        child:
                            SecretarySavePage(secretaryModel: secretaryModel),
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
                      builder: (_) =>
                          SecretaryViewPage(secretaryModel: secretaryModel),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.assignment_ind_outlined,
                ),
              ),
              // IconButton(
              //   onPressed: () => copy(secretaryModel.id!),
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
