import 'package:agendarep/app/core/models/expertise_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/medical_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/medical_repository.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/medical_search_bloc.dart';
import '../search/bloc/medical_search_event.dart';
import 'bloc/medical_save_bloc.dart';
import 'bloc/medical_save_event.dart';
import 'bloc/medical_save_state.dart';

class MedicalSavePage extends StatelessWidget {
  final MedicalModel? medicalModel;

  const MedicalSavePage({super.key, this.medicalModel});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MedicalRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return MedicalSaveBloc(
              medicalModel: medicalModel,
              medicalRepository:
                  RepositoryProvider.of<MedicalRepository>(context),
              seller: userProfile);
        },
        child: MedicalSaveView(
          medicalModel: medicalModel,
        ),
      ),
    );
  }
}

class MedicalSaveView extends StatefulWidget {
  final MedicalModel? medicalModel;
  const MedicalSaveView({Key? key, required this.medicalModel})
      : super(key: key);

  @override
  State<MedicalSaveView> createState() => _MedicalSaveViewState();
}

class _MedicalSaveViewState extends State<MedicalSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTEC = TextEditingController();
  final _nameTEC = TextEditingController();
  final _phoneTEC = TextEditingController();
  final _crmTEC = TextEditingController();
  DateTime _birthday = DateTime.now();
  bool delete = false;
  bool isBlocked = false;
  @override
  void initState() {
    super.initState();
    _emailTEC.text = widget.medicalModel?.email ?? "";
    _nameTEC.text = widget.medicalModel?.name ?? "";
    _phoneTEC.text = widget.medicalModel?.phone ?? "";
    _crmTEC.text = widget.medicalModel?.crm ?? "";
    _birthday = widget.medicalModel?.birthday ?? DateTime.now();
    isBlocked = widget.medicalModel?.isBlocked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar ou Editar médico'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<MedicalSaveBloc>().add(
                  MedicalSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<MedicalSaveBloc>().add(
                    MedicalSaveEventFormSubmitted(
                      email: _emailTEC.text,
                      name: _nameTEC.text,
                      phone: _phoneTEC.text,
                      crm: _crmTEC.text,
                      isBlocked: isBlocked,
                      birthday: _birthday,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<MedicalSaveBloc, MedicalSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == MedicalSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == MedicalSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.medicalModel != null) {
              if (delete) {
                context.read<MedicalSearchBloc>().add(
                    MedicalSearchEventRemoveFromList(state.medicalModel!.id!));
              } else {
                context
                    .read<MedicalSearchBloc>()
                    .add(MedicalSearchEventUpdateList(state.medicalModel!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == MedicalSaveStateStatus.loading) {
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
                        label: 'Nome *',
                        controller: _nameTEC,
                        validator: Validatorless.required('Nome é obrigatório'),
                      ),
                      const Divider(height: 5),
                      const Text('Selecione uma Especialidade'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<MedicalSaveBloc>();
                                ExpertiseModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/expertise/select')
                                        as ExpertiseModel?;
                                if (result != null) {
                                  contextTemp.add(
                                      MedicalSaveEventAddExpertise(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<MedicalSaveBloc, MedicalSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.expertisesUpdated
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Text('${e.name}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context.read<MedicalSaveBloc>().add(
                                                  MedicalSaveEventRemoveExpertise(
                                                      e));
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                          const SizedBox(width: 15)
                        ],
                      ),
                      AppTextFormField(
                        label: 'email',
                        controller: _emailTEC,
                      ),
                      AppTextFormField(
                        label: 'Telefone pessoal do médico. Formato DDDNUMERO',
                        controller: _phoneTEC,
                        validator: Validatorless.number('Apenas números.'),
                      ),
                      AppTextFormField(
                        label: 'CRM',
                        controller: _crmTEC,
                      ),
                      CheckboxListTile(
                        title: const Text("Cadastrado no painel ?"),
                        onChanged: (value) {
                          setState(() {
                            isBlocked = value ?? false;
                          });
                        },
                        value: isBlocked,
                      ),
                      const SizedBox(height: 5),
                      const Text('Aniversário'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _birthday,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            _birthday = newDate;
                          },
                        ),
                      ),
                      if (widget.medicalModel != null)
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
