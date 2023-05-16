import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/secretary_model.dart';
import '../../../../../routes.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/secretary_save_page.dart';
import '../../bloc/secretary_search_bloc.dart';

class SecretaryCard extends StatelessWidget {
  final SecretaryModel model;
  const SecretaryCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');

    return Card(
      child: Column(
        children: [
          // AppTextTitleValue(
          //   title: 'Id: ',
          //   value: model.id,
          // ),
          // AppTextTitleValue(
          //   title: 'Cadastrada pelo Representante: ',
          //   value: model.seller?.name,
          // ),
          // AppTextTitleValue(
          //   title: 'Email: ',
          //   value: model.email,
          // ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: model.name,
          ),
          AppTextTitleValue(
            title: 'Telefone: ',
            value: model.phone,
          ),
          // AppTextTitleValue(
          //   title: 'Data de Aniversário: ',
          //   value: dateFormat.format(model.birthday!),
          // ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<SecretarySearchBloc>(context),
                        child: SecretarySavePage(model: model),
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
                  //     builder: (_) => SecretaryViewPage(model: model),
                  //   ),
                  // );
                  context.pushNamed(
                    AppPage.secretaryView.name,
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
