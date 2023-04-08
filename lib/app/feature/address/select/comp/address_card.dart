import 'package:flutter/material.dart';

import '../../../../core/models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel model;
  const AddressCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.name}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
