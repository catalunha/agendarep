import 'package:flutter/material.dart';

import '../../../../core/models/secretary_model.dart';

class SecretaryCard extends StatelessWidget {
  final SecretaryModel model;
  const SecretaryCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.name}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
