import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/secretary_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/secretary_repository.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/secretary_search_bloc.dart';
import '../search/bloc/secretary_search_event.dart';
import 'bloc/secretary_add_edit_bloc.dart';
import 'bloc/secretary_add_edit_event.dart';
import 'bloc/secretary_add_edit_state.dart';

class SecretaryAddEditPage extends StatelessWidget {
  final SecretaryModel? secretaryModel;

  const SecretaryAddEditPage({super.key, this.secretaryModel});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SecretaryRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return SecretaryAddEditBloc(
              secretaryModel: secretaryModel,
              secretaryRepository:
                  RepositoryProvider.of<SecretaryRepository>(context),
              seller: userProfile);
        },
        child: SecretaryAddEditView(
          secretaryModel: secretaryModel,
        ),
      ),
    );
  }
}

class SecretaryAddEditView extends StatefulWidget {
  final SecretaryModel? secretaryModel;
  const SecretaryAddEditView({Key? key, required this.secretaryModel})
      : super(key: key);

  @override
  State<SecretaryAddEditView> createState() => _SecretaryAddEditViewState();
}

class _SecretaryAddEditViewState extends State<SecretaryAddEditView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTEC = TextEditingController();
  final _nameTEC = TextEditingController();
  final _phoneTEC = TextEditingController();
  final _descriptionTEC = TextEditingController();
  DateTime _birthday = DateTime.now();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _emailTEC.text = widget.secretaryModel?.email ?? "";
    _nameTEC.text = widget.secretaryModel?.name ?? "";
    _phoneTEC.text = widget.secretaryModel?.phone ?? "";
    _birthday = widget.secretaryModel?.birthday ?? DateTime.now();
    _descriptionTEC.text = widget.secretaryModel?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar ou Editar secretária'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<SecretaryAddEditBloc>().add(
                  SecretaryAddEditEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<SecretaryAddEditBloc>().add(
                    SecretaryAddEditEventFormSubmitted(
                      email: _emailTEC.text,
                      name: _nameTEC.text,
                      phone: _phoneTEC.text,
                      birthday: _birthday,
                      description: _descriptionTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<SecretaryAddEditBloc, SecretaryAddEditState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == SecretaryAddEditStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == SecretaryAddEditStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.secretaryModel != null) {
              if (delete) {
                context.read<SecretarySearchBloc>().add(
                    SecretarySearchEventRemoveFromList(
                        state.secretaryModel!.id!));
              } else {
                context
                    .read<SecretarySearchBloc>()
                    .add(SecretarySearchEventUpdateList(state.secretaryModel!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == SecretaryAddEditStateStatus.loading) {
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
                      AppTextFormField(
                        label: 'Descrição',
                        controller: _descriptionTEC,
                      ),
                      if (widget.secretaryModel != null)
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
