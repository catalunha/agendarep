import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/address_model.dart';
import '../../../core/models/clinic_model.dart';
import '../../../core/models/medical_model.dart';
import '../../../core/models/secretary_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/clinic_repository.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/clinic_search_bloc.dart';
import '../search/bloc/clinic_search_event.dart';
import 'bloc/clinic_save_bloc.dart';
import 'bloc/clinic_save_event.dart';
import 'bloc/clinic_save_state.dart';

class ClinicSavePage extends StatelessWidget {
  final ClinicModel? model;

  const ClinicSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ClinicRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return ClinicSaveBloc(
              clinicModel: model,
              clinicRepository:
                  RepositoryProvider.of<ClinicRepository>(context),
              seller: userProfile);
        },
        child: ClinicSaveView(
          model: model,
        ),
      ),
    );
  }
}

class ClinicSaveView extends StatefulWidget {
  final ClinicModel? model;
  const ClinicSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<ClinicSaveView> createState() => _ClinicSaveViewState();
}

class _ClinicSaveViewState extends State<ClinicSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTEC = TextEditingController();
  final _roomTEC = TextEditingController();
  final _phoneTEC = TextEditingController();
  final _descriptionTEC = TextEditingController();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _nameTEC.text = widget.model?.room ?? "";
    _roomTEC.text = widget.model?.room ?? "";
    _phoneTEC.text = widget.model?.phone ?? "";
    _descriptionTEC.text = widget.model?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar ou Editar Clinica'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<ClinicSaveBloc>().add(
                  ClinicSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<ClinicSaveBloc>().add(
                    ClinicSaveEventFormSubmitted(
                      name: _nameTEC.text,
                      room: _roomTEC.text,
                      phone: _phoneTEC.text,
                      description: _descriptionTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<ClinicSaveBloc, ClinicSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ClinicSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ClinicSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<ClinicSearchBloc>()
                    .add(ClinicSearchEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<ClinicSearchBloc>()
                    .add(ClinicSearchEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == ClinicSaveStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Center(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      AppTextFormField(
                        label: 'Nome',
                        controller: _nameTEC,
                        validator: Validatorless.required('Nome é obrigatório'),
                      ),
                      AppTextFormField(
                        label: 'Sala',
                        controller: _roomTEC,
                      ),
                      AppTextFormField(
                        label: 'Telefone. Formato DDDNUMERO',
                        controller: _phoneTEC,
                        validator: Validatorless.number('Apenas números.'),
                      ),
                      AppTextFormField(
                        label: 'Descrição',
                        controller: _descriptionTEC,
                      ),
                      const Text('Selecione o médico'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<ClinicSaveBloc>();
                                MedicalModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/medical/select')
                                        as MedicalModel?;
                                if (result != null) {
                                  contextTemp
                                      .add(ClinicSaveEventAddMedical(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<ClinicSaveBloc, ClinicSaveState>(
                            builder: (context, state) {
                              return Text('${state.medical?.name}');
                            },
                          ),
                        ],
                      ),
                      const Text('Selecione o endereço'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<ClinicSaveBloc>();
                                AddressModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/address/select')
                                        as AddressModel?;
                                if (result != null) {
                                  contextTemp
                                      .add(ClinicSaveEventAddAddress(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<ClinicSaveBloc, ClinicSaveState>(
                            builder: (context, state) {
                              return Text('${state.address?.name}');
                            },
                          ),
                        ],
                      ),
                      const Text('Selecione as secretarias'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<ClinicSaveBloc>();
                                SecretaryModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/secretary/select')
                                        as SecretaryModel?;
                                if (result != null) {
                                  contextTemp
                                      .add(ClinicSaveEventAddSecretary(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<ClinicSaveBloc, ClinicSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.secretariesUpdated
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Text('${e.name}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context
                                                  .read<ClinicSaveBloc>()
                                                  .add(
                                                    ClinicSaveEventRemoveSecretary(
                                                      e,
                                                    ),
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ],
                      ),
                      if (widget.model != null)
                        CheckboxListTile(
                          tileColor: delete ? Colors.red : null,
                          title: const Text("Apagar este cadastro ?"),
                          onChanged: (value) {
                            setState(() {
                              delete = value ?? false;
                            });
                          },
                          value: delete,
                        ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
