import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';
import '../../../utils/app_textformfield.dart';
import '../bloc/speed_save_bloc.dart';
import '../bloc/speed_save_event.dart';
import '../bloc/speed_save_state.dart';

class SpeedMedical extends StatelessWidget {
  const SpeedMedical({
    super.key,
    required TextEditingController medicalNameTEC,
    required TextEditingController medicalPhoneTEC,
    required TextEditingController medicalEmailTEC,
    required TextEditingController medicalCrmTEC,
  })  : _medicalNameTEC = medicalNameTEC,
        _medicalPhoneTEC = medicalPhoneTEC,
        _medicalEmailTEC = medicalEmailTEC,
        _medicalCrmTEC = medicalCrmTEC;

  final TextEditingController _medicalNameTEC;
  final TextEditingController _medicalPhoneTEC;
  final TextEditingController _medicalEmailTEC;
  final TextEditingController _medicalCrmTEC;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const Text('Selecione ou adicione um novo médico'),
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  var contextTemp = context.read<SpeedSaveBloc>();
                  MedicalModel? result = await Navigator.of(context)
                      .pushNamed('/medical/select') as MedicalModel?;
                  if (result != null) {
                    contextTemp.add(SpeedSaveEventSetMedical(result));
                  }
                },
                icon: const Icon(Icons.search)),
            BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.medical != null,
                  child: Row(
                    children: [
                      Text('${state.medical?.name}'),
                      IconButton(
                          onPressed: () {
                            context
                                .read<SpeedSaveBloc>()
                                .add(SpeedSaveEventSetMedical(null));
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
              visible: state.medical == null,
              child: Column(
                children: [
                  AppTextFormField(
                    label: '* Nome do médico',
                    controller: _medicalNameTEC,
                    validator: state.medical == null
                        ? Validatorless.required(
                            'Esta informação é obrigatória')
                        : null,
                  ),
                  const Divider(height: 5),
                  const Text('Selecione a especialidade deste médico'),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            var contextTemp = context.read<SpeedSaveBloc>();
                            ExpertiseModel? result = await Navigator.of(context)
                                    .pushNamed('/expertise/select')
                                as ExpertiseModel?;
                            if (result != null) {
                              contextTemp
                                  .add(SpeedSaveEventSetExpertise(result));
                            }
                          },
                          icon: const Icon(Icons.search)),
                      BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
                        builder: (context, state) {
                          return Visibility(
                            visible: state.expertise != null,
                            child: Row(
                              children: [
                                Text('${state.expertise?.name}'),
                                IconButton(
                                    onPressed: () {
                                      context.read<SpeedSaveBloc>().add(
                                          SpeedSaveEventSetExpertise(null));
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 15)
                    ],
                  ),
                  AppTextFormField(
                    label: 'Telefone pessoal do médico. Formato DDDNUMERO',
                    controller: _medicalPhoneTEC,
                    validator: Validatorless.number('Apenas números.'),
                  ),
                  // AppTextFormField(
                  //   label: 'email',
                  //   controller: _medicalEmailTEC,
                  // ),
                  AppTextFormField(
                    label: 'CRM',
                    controller: _medicalCrmTEC,
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
