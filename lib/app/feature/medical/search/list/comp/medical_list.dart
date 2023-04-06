import 'package:flutter/material.dart';

import '../../../../../core/models/medical_model.dart';
import 'medical_card.dart';

class MedicalList extends StatelessWidget {
  final List<MedicalModel> cautionList;
  const MedicalList({
    super.key,
    required this.cautionList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cautionList.length,
      itemBuilder: (context, index) {
        final item = cautionList[index];
        return MedicalCard(
          medicalModel: item,
        );
      },
    );
  }
}
