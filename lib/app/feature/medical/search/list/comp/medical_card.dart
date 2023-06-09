import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/medical_model.dart';
import '../../../../../routes.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/medical_save_page.dart';
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
          AppTextTitleValue(
            title: 'CRM: ',
            value: model.crm,
          ),
          // AppTextTitleValue(
          //   title: 'Cadastrado no painel: ',
          //   value: model.isBlocked ?? true ? 'Sim' : 'Não',
          // ),
          // AppTextTitleValue(
          //   title: 'Data de Aniversário: ',
          //   value: dateFormat.format(model.birthday!),
          // ),
          AppTextTitleValue(
            title: 'Especialidades: ',
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
                        child: MedicalSavePage(medicalModel: model),
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
                  //     builder: (_) => MedicalViewPage(model: model),
                  //   ),
                  // );
                  context.pushNamed(
                    AppPage.medicalView.name,
                    extra: model,
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
