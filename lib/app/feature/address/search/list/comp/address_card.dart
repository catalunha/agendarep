import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/address_model.dart';
import '../../../../../routes.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/address_save_page.dart';
import '../../bloc/address_search_bloc.dart';

class AddressCard extends StatelessWidget {
  final AddressModel model;
  const AddressCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('dd/MM/y');

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
            title: 'Nome: ',
            value: model.name,
          ),
          AppTextTitleValue(
            title: 'Telefone: ',
            value: model.phone,
          ),
          // AppTextTitleValue(
          //   title: 'Descrição: ',
          //   value: model.description,
          // ),
          // AppTextTitleValue(
          //   title: 'Região: ',
          //   value: model.region?.name,
          //   inColumn: true,
          // ),
          // AppTextTitleValue(
          //   title: 'Geopoint: ',
          //   value: model.parseGeoPoint.toString(),
          //   inColumn: true,
          // ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<AddressSearchBloc>(context),
                        child: AddressSavePage(model: model),
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
                  //     builder: (_) => AddressViewPage(model: model),
                  //   ),
                  // );
                  // context.go('/home/address/view', extra: model);
                  context.pushNamed(AppPage.addressView.name, extra: model);
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
