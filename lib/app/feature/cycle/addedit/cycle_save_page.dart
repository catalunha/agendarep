import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/cycle_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/cycle_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/cycle_list_bloc.dart';
import '../list/bloc/cycle_list_event.dart';
import 'bloc/cycle_save_bloc.dart';
import 'bloc/cycle_save_event.dart';
import 'bloc/cycle_save_state.dart';

class CycleSavePage extends StatelessWidget {
  final CycleModel? model;

  const CycleSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CycleRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return CycleSaveBloc(
              cycleModel: model,
              cycleRepository: RepositoryProvider.of<CycleRepository>(context),
              seller: userProfile);
        },
        child: CycleSaveView(
          model: model,
        ),
      ),
    );
  }
}

class CycleSaveView extends StatefulWidget {
  final CycleModel? model;
  const CycleSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<CycleSaveView> createState() => _CycleSaveViewState();
}

class _CycleSaveViewState extends State<CycleSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTEC = TextEditingController();
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  bool delete = false;
  bool isArchived = false;
  @override
  void initState() {
    super.initState();
    _nameTEC.text = widget.model?.name ?? "";
    _start = widget.model?.start ?? DateTime.now();
    _end = widget.model?.end ?? DateTime.now();
    isArchived = widget.model?.isArchived ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar ou Editar Ciclo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<CycleSaveBloc>().add(
                  CycleSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<CycleSaveBloc>().add(
                    CycleSaveEventFormSubmitted(
                      name: _nameTEC.text,
                      isArchived: isArchived,
                      start: _start,
                      end: _end,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<CycleSaveBloc, CycleSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == CycleSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == CycleSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<CycleListBloc>()
                    .add(CycleListEventRemoveFromList(state.cycleModel!.id!));
              } else {
                context
                    .read<CycleListBloc>()
                    .add(CycleListEventUpdateList(state.cycleModel!));
              }
            } else {
              context.read<CycleListBloc>().add(CycleListEventIsArchived());
            }
            Navigator.of(context).pop();
          }
          if (state.status == CycleSaveStateStatus.loading) {
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
                      CheckboxListTile(
                        title: const Text("Arquivar este cadastro ?"),
                        onChanged: (value) {
                          setState(() {
                            isArchived = value ?? false;
                          });
                        },
                        value: isArchived,
                      ),
                      const SizedBox(height: 5),
                      const Text('Inicio'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _start,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            _start = newDate;
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Fim'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: _end,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            _end = newDate;
                          },
                        ),
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
