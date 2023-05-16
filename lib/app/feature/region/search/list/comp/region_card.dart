import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/region_model.dart';
import '../../../../../routes.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../save/region_save_page.dart';
import '../../bloc/region_search_bloc.dart';

class RegionCard extends StatelessWidget {
  final RegionModel model;
  const RegionCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // AppTextTitleValue(
          //   title: 'Id: ',
          //   value: model.id,
          // ),
          AppTextTitleValue(
            title: 'Estado: ',
            value: model.uf,
          ),
          AppTextTitleValue(
            title: 'Cidade: ',
            value: model.city,
          ),
          AppTextTitleValue(
            title: 'Nome: ',
            value: model.name,
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<RegionSearchBloc>(context),
                        child: RegionSavePage(model: model),
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
                  // context.go('/home/region/view', extra: model);
                  // context.goNamed(
                  //   AppPage.regionView.name,
                  //   extra: ExtraObject(
                  //     context: context,
                  //     regionModel: model,
                  //   ),
                  // );
                  // context.pushNamed(
                  //   'viewRegion',
                  //   extra: ExtraObject(
                  //     context: context,
                  //     regionModel: model,
                  //   ),
                  // );
                  context.pushNamed(
                    AppPage.regionView.name,
                    extra: model,
                  );
                  // context.goNamed(
                  //   AppPage.regionView.name,
                  //   extra: model,
                  // );
                  // context.push('/home/region/view', extra: model);
                  // Navigator.of(context).pushNamed(routeName,arguments: );

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => RegionViewPage(model: model),
                  //   ),
                  // );
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
