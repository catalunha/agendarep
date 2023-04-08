import 'package:flutter/material.dart';

import '../../../../core/models/medical_model.dart';

class MedicalCard extends StatelessWidget {
  final MedicalModel model;
  const MedicalCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.name}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
