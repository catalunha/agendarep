import 'package:flutter/material.dart';

import '../../../core/models/address_model.dart';
import '../../utils/app_text_title_value.dart';

class AddressViewPage extends StatelessWidget {
  final AddressModel model;
  const AddressViewPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados deste endereço')),
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
                  title: 'Descrição: ',
                  value: model.description,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Região: ',
                  value: model.region?.name,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Geopoint: ',
                  value: model.parseGeoPoint.toString(),
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
