import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/medical_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../addedit/medical_addedit_page.dart';
import '../../../view/medical_view_page.dart';
import '../../bloc/medical_search_bloc.dart';

class MedicalCard extends StatelessWidget {
  final MedicalModel model;
  const MedicalCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');

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
            title: 'Email: ',
            value: model.email,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: model.name,
          ),
          AppTextTitleValue(
            title: 'Telefone: ',
            value: model.phone,
          ),
          AppTextTitleValue(
            title: 'CRM: ',
            value: model.crm,
          ),
          AppTextTitleValue(
            title: 'Bloqueado: ',
            value: model.isBlocked ?? false ? 'Bloqueado' : 'Desbloqueado',
          ),
          AppTextTitleValue(
            title: 'Data de Aniversário: ',
            value: dateFormat.format(model.birthday!),
          ),
          AppTextTitleValue(
            title: 'Descrição: ',
            value: model.description,
          ),
          AppTextTitleValue(
            title: 'Descrição: ',
            value: model.expertises?.map((e) => e.name).toList().join(', '),
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<MedicalSearchBloc>(context),
                        child: MedicalAddEditPage(medicalModel: model),
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
                      builder: (_) => MedicalViewPage(medicalModel: model),
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
