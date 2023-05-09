import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/models/secretary_model.dart';
import '../../../utils/app_textformfield.dart';
import '../bloc/speed_save_bloc.dart';
import '../bloc/speed_save_event.dart';
import '../bloc/speed_save_state.dart';

class SpeedSecretary extends StatelessWidget {
  const SpeedSecretary({
    super.key,
    required TextEditingController secretaryNameTEC,
    required TextEditingController secretaryPhoneTEC,
    required TextEditingController secretaryEmailTEC,
  })  : _secretaryNameTEC = secretaryNameTEC,
        _secretaryPhoneTEC = secretaryPhoneTEC,
        _secretaryEmailTEC = secretaryEmailTEC;

  final TextEditingController _secretaryNameTEC;
  final TextEditingController _secretaryPhoneTEC;
  final TextEditingController _secretaryEmailTEC;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const Text('Selecione ou adicione uma secretaria'),
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  var contextTemp = context.read<SpeedSaveBloc>();
                  SecretaryModel? result = await Navigator.of(context)
                      .pushNamed('/secretary/select') as SecretaryModel?;
                  if (result != null) {
                    contextTemp.add(SpeedSaveEventSetSecretary(result));
                  }
                },
                icon: const Icon(Icons.search)),
            BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.secretary != null,
                  child: Row(
                    children: [
                      Text('${state.secretary?.name}'),
                      IconButton(
                          onPressed: () {
                            context
                                .read<SpeedSaveBloc>()
                                .add(SpeedSaveEventSetSecretary(null));
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
                    controller: _secretaryNameTEC,
                    validator: state.secretary == null
                        ? Validatorless.required(
                            'Esta informação é obrigatória')
                        : null,
                  ),
                  const Divider(height: 5),
                  AppTextFormField(
                    label: 'Telefone pessoal da secretaria. Formato DDDNUMERO',
                    controller: _secretaryPhoneTEC,
                    validator: state.secretary == null
                        ? Validatorless.number('Apenas números.')
                        : null,
                  ),
                  // AppTextFormField(
                  //   label: 'email',
                  //   controller: _secretaryEmailTEC,
                  // ),
                ],
              ),
            );
          },
        ),
      ]),
    );
  }
}
