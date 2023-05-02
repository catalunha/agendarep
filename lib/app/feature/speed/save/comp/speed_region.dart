import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/models/region_model.dart';
import '../../../utils/app_textformfield.dart';
import '../bloc/speed_save_bloc.dart';
import '../bloc/speed_save_event.dart';
import '../bloc/speed_save_state.dart';

class SpeedRegion extends StatelessWidget {
  const SpeedRegion({
    super.key,
    required TextEditingController regionUfTEC,
    required TextEditingController regionCityTEC,
    required TextEditingController regionNameTEC,
  })  : _regionUfTEC = regionUfTEC,
        _regionCityTEC = regionCityTEC,
        _regionNameTEC = regionNameTEC;

  final TextEditingController _regionUfTEC;
  final TextEditingController _regionCityTEC;
  final TextEditingController _regionNameTEC;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const Text('Selecione ou adicione uma região'),
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  var contextTemp = context.read<SpeedSaveBloc>();
                  RegionModel? result = await Navigator.of(context)
                      .pushNamed('/region/select') as RegionModel?;
                  if (result != null) {
                    contextTemp.add(SpeedSaveEventSetRegion(result));
                  }
                },
                icon: const Icon(Icons.search)),
            BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.region != null,
                  child: Row(
                    children: [
                      Text('${state.region?.name}'),
                      IconButton(
                          onPressed: () {
                            context
                                .read<SpeedSaveBloc>()
                                .add(SpeedSaveEventSetRegion(null));
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
          builder: (context, state) {
            return Visibility(
              visible: state.region == null,
              child: Column(
                children: [
                  AppTextFormField(
                    label: 'Estado *',
                    controller: _regionUfTEC,
                    validator: state.region == null
                        ? Validatorless.required(
                            'Esta informação é obrigatória')
                        : null,
                  ),
                  AppTextFormField(
                    label: 'Cidade *',
                    controller: _regionCityTEC,
                    validator: state.region == null
                        ? Validatorless.required(
                            'Esta informação é obrigatória')
                        : null,
                  ),
                  AppTextFormField(
                    label:
                        'Nome * (Centro, Setor X, Bairro Y, Quadras A B C, etc)',
                    controller: _regionNameTEC,
                    validator: state.region == null
                        ? Validatorless.required(
                            'Esta informação é obrigatória')
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ]),
    );
  }
}
