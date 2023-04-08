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
import 'bloc/medical_add_edit_bloc.dart';
import 'bloc/medical_add_edit_event.dart';
import 'bloc/medical_add_edit_state.dart';

class MedicalAddEditPage extends StatelessWidget {
  final MedicalModel? medicalModel;

  const MedicalAddEditPage({super.key, this.medicalModel});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MedicalRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return MedicalAddEditBloc(
              medicalModel: medicalModel,
              medicalRepository:
                  RepositoryProvider.of<MedicalRepository>(context),
              seller: userProfile);
        },
        child: MedicalAddEditView(
          medicalModel: medicalModel,
        ),
      ),
    );
  }
}

class MedicalAddEditView extends StatefulWidget {
  final MedicalModel? medicalModel;
  const MedicalAddEditView({Key? key, required this.medicalModel})
      : super(key: key);

  @override
  State<MedicalAddEditView> createState() => _MedicalAddEditViewState();
}

class _MedicalAddEditViewState extends State<MedicalAddEditView> {
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
            context.read<MedicalAddEditBloc>().add(
                  MedicalAddEditEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<MedicalAddEditBloc>().add(
                    MedicalAddEditEventFormSubmitted(
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
      body: BlocListener<MedicalAddEditBloc, MedicalAddEditState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == MedicalAddEditStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == MedicalAddEditStateStatus.success) {
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
          if (state.status == MedicalAddEditStateStatus.loading) {
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
                        label: 'email',
                        controller: _emailTEC,
                      ),
                      AppTextFormField(
                        label: 'Nome',
                        controller: _nameTEC,
                        validator: Validatorless.required('Nome é obrigatório'),
                      ),
                      AppTextFormField(
                        label: 'Telefone. Formato DDDNUMERO',
                        controller: _phoneTEC,
                        validator: Validatorless.number('Apenas números.'),
                      ),
                      AppTextFormField(
                        label: 'CRM',
                        controller: _crmTEC,
                      ),
                      CheckboxListTile(
                        title: const Text("Bloquear este cadastro ?"),
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
                      const Text('Selecione uma Especialidade'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<MedicalAddEditBloc>();
                                ExpertiseModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/expertise/select')
                                        as ExpertiseModel?;
                                if (result != null) {
                                  contextTemp.add(
                                      MedicalAddEditEventAddExpertise(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<MedicalAddEditBloc, MedicalAddEditState>(
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
                                              context
                                                  .read<MedicalAddEditBloc>()
                                                  .add(
                                                      MedicalAddEditEventRemoveExpertise(
                                                          e));
                                            },
                                          ),
                                        ],
                                      ),
                                      // (e) => SizedBox(
                                      //   width: 200,
                                      //   child: ListTile(
                                      //     title: Text('${e.name}'),
                                      //     trailing: IconButton(
                                      //       icon: const Icon(Icons.delete),
                                      //       onPressed: () {
                                      //         context
                                      //             .read<MedicalAddEditBloc>()
                                      //             .add(
                                      //                 MedicalAddEditEventRemoveExpertise(
                                      //                     e));
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                          const SizedBox(width: 15)
                        ],
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
