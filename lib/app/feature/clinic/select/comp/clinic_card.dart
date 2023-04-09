import 'package:flutter/material.dart';

import '../../../../core/models/clinic_model.dart';

class ClinicCard extends StatelessWidget {
  final ClinicModel model;
  const ClinicCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.name}'),
      onTap: () => Navigator.of(context).pop(model),
    );
  }
}
