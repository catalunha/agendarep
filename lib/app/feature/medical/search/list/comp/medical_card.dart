import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/medical_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../addedit/medical_addedit_page.dart';
import '../../../view/medical_view_page.dart';
import '../../bloc/medical_search_bloc.dart';

class MedicalCard extends StatelessWidget {
  final MedicalModel medicalModel;
  const MedicalCard({Key? key, required this.medicalModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y');

    return Card(
      child: Column(
        children: [
          AppTextTitleValue(
            title: 'Id: ',
            value: medicalModel.id,
          ),
          AppTextTitleValue(
            title: 'Cadastrada pelo Representante: ',
            value: medicalModel.seller?.name,
          ),
          AppTextTitleValue(
            title: 'Email: ',
            value: medicalModel.email,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: medicalModel.name,
          ),
          AppTextTitleValue(
            title: 'Telefone: ',
            value: medicalModel.phone,
          ),
          AppTextTitleValue(
            title: 'CRM: ',
            value: medicalModel.crm,
            inColumn: true,
          ),
          AppTextTitleValue(
            title: 'Bloqueado: ',
            value:
                medicalModel.isBlocked ?? false ? 'Bloqueado' : 'Desbloqueado',
            inColumn: true,
          ),
          AppTextTitleValue(
            title: 'Data de Aniversário: ',
            value: dateFormat.format(medicalModel.birthday!),
          ),
          AppTextTitleValue(
            title: 'Descrição: ',
            value: medicalModel.description,
          ),
          AppTextTitleValue(
            title: 'Descrição: ',
            value:
                medicalModel.expertises?.map((e) => e.name).toList().join(', '),
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<MedicalSearchBloc>(context),
                        child: MedicalAddEditPage(medicalModel: medicalModel),
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
                          MedicalViewPage(medicalModel: medicalModel),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.assignment_ind_outlined,
                ),
              ),
              // IconButton(
              //   onPressed: () => copy(medicalModel.id!),
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
