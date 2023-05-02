import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/models/clinic_model.dart';
import '../../../utils/app_textformfield.dart';
import '../bloc/speed_save_bloc.dart';
import '../bloc/speed_save_event.dart';
import '../bloc/speed_save_state.dart';

class SpeedClinic extends StatelessWidget {
  const SpeedClinic({
    super.key,
    required TextEditingController clinicNameTEC,
    required TextEditingController clinicPhoneTEC,
    required TextEditingController clinicRoomTEC,
  })  : _clinicNameTEC = clinicNameTEC,
        _clinicPhoneTEC = clinicPhoneTEC,
        _clinicRoomTEC = clinicRoomTEC;

  final TextEditingController _clinicNameTEC;
  final TextEditingController _clinicPhoneTEC;
  final TextEditingController _clinicRoomTEC;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const Text('Selecione ou adicione uma clinica'),
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  var contextTemp = context.read<SpeedSaveBloc>();
                  ClinicModel? result = await Navigator.of(context)
                      .pushNamed('/clinic/select') as ClinicModel?;
                  if (result != null) {
                    contextTemp.add(SpeedSaveEventSetClinic(result));
                  }
                },
                icon: const Icon(Icons.search)),
            BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.clinic != null,
                  child: Row(
                    children: [
                      Text('${state.clinic?.name}'),
                      IconButton(
                          onPressed: () {
                            context
                                .read<SpeedSaveBloc>()
                                .add(SpeedSaveEventSetClinic(null));
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
              visible: state.secretary == null,
              child: Column(
                children: [
                  AppTextFormField(
                    label: 'Nome *',
                    controller: _clinicNameTEC,
                    validator: state.clinic == null
                        ? Validatorless.required(
                            'Esta informação é obrigatória')
                        : null,
                  ),
                  const Divider(height: 5),
                  AppTextFormField(
                    label: 'Telefone pessoal da secretaria. Formato DDDNUMERO',
                    controller: _clinicPhoneTEC,
                    validator: state.clinic == null
                        ? Validatorless.number('Apenas números.')
                        : null,
                  ),
                  AppTextFormField(
                    label: 'Sala',
                    controller: _clinicRoomTEC,
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
