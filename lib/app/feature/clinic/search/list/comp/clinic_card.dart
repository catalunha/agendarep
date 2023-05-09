import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/clinic_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/clinic_save_page.dart';
import '../../../view/clinic_view_page.dart';
import '../../bloc/clinic_search_bloc.dart';

class ClinicCard extends StatelessWidget {
  final ClinicModel model;
  const ClinicCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          AppTextTitleValue(
            title: 'Medico: ',
            value: model.medical?.name,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: model.name,
          ),
          // AppTextTitleValue(
          //   title: 'Sala: ',
          //   value: model.room,
          // ),
          // AppTextTitleValue(
          //   title: 'Telefone: ',
          //   value: model.phone,
          // ),
          // AppTextTitleValue(
          //   title: 'Endereço: ',
          //   value: model.address?.description,
          //   inColumn: true,
          // ),
          // AppTextTitleValue(
          //   title: 'Região: ',
          //   value: model.address?.region?.name,
          //   inColumn: true,
          // ),
          // AppTextTitleValue(
          //   title: 'Secretarias: ',
          //   value: model.secretaries?.map((e) => e.name).toList().join(', '),
          // ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ClinicSearchBloc>(context),
                        child: ClinicSavePage(model: model),
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
                      builder: (_) => ClinicViewPage(model: model),
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
