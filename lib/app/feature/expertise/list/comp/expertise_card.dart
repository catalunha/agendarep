import 'package:flutter/material.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../utils/app_text_title_value.dart';

class ExpertiseCard extends StatelessWidget {
  final ExpertiseModel model;
  const ExpertiseCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AppTextTitleValue(
            title: 'Id: ',
            value: model.id,
          ),
          AppTextTitleValue(
            title: 'Código: ',
            value: model.code,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: model.name,
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  // Get.back(result: imageModel)
                  Navigator.of(context).pop(model);
                },
                icon: const Icon(
                  Icons.check,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
