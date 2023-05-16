import 'package:flutter/material.dart';

import '../../../../../core/models/secretary_model.dart';
import 'secretary_card.dart';

class SecretaryList extends StatelessWidget {
  final List<SecretaryModel> cautionList;
  const SecretaryList({
    super.key,
    required this.cautionList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cautionList.length,
      itemBuilder: (context, index) {
        final item = cautionList[index];
        return SecretaryCard(
          model: item,
        );
      },
    );
  }
}
