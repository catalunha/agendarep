import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/models/address_model.dart';
import '../../../utils/app_textformfield.dart';
import '../bloc/speed_save_bloc.dart';
import '../bloc/speed_save_event.dart';
import '../bloc/speed_save_state.dart';

class SpeedAddress extends StatelessWidget {
  const SpeedAddress({
    super.key,
    required TextEditingController addressNameTEC,
    required TextEditingController addressPhoneTEC,
    required TextEditingController addressDescriptionTEC,
  })  : _addressNameTEC = addressNameTEC,
        _addressPhoneTEC = addressPhoneTEC,
        _addressDescriptionTEC = addressDescriptionTEC;

  final TextEditingController _addressNameTEC;
  final TextEditingController _addressPhoneTEC;
  final TextEditingController _addressDescriptionTEC;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const Text('Selecione ou adicione um endereço'),
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  var contextTemp = context.read<SpeedSaveBloc>();
                  AddressModel? result = await Navigator.of(context)
                      .pushNamed('/address/select') as AddressModel?;
                  if (result != null) {
                    contextTemp.add(SpeedSaveEventSetAddress(result));
                  }
                },
                icon: const Icon(Icons.search)),
            BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.address != null,
                  child: Row(
                    children: [
                      Text('${state.address?.name}'),
                      IconButton(
                          onPressed: () {
                            context
                                .read<SpeedSaveBloc>()
                                .add(SpeedSaveEventSetAddress(null));
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
              visible: state.address == null,
              child: Column(
                children: [
                  AppTextFormField(
                    label: 'Nome * (Hospital X, Edificio Médico Y, etc)',
                    controller: _addressNameTEC,
                    validator: state.address == null
                        ? Validatorless.required(
                            'Esta informação é obrigatória')
                        : null,
                  ),
                  const Divider(height: 5),
                  AppTextFormField(
                    label: 'Telefone do prédio. Formato DDDNUMERO',
                    controller: _addressPhoneTEC,
                    validator: state.address == null
                        ? Validatorless.number('Apenas números.')
                        : null,
                  ),
                  AppTextFormField(
                    label: 'Descrição (Rua X, )',
                    controller: _addressDescriptionTEC,
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
