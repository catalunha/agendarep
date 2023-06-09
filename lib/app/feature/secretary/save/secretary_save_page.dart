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
import 'bloc/secretary_save_bloc.dart';
import 'bloc/secretary_save_event.dart';
import 'bloc/secretary_save_state.dart';

class SecretarySavePage extends StatelessWidget {
  final SecretaryModel? model;

  const SecretarySavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SecretaryRepository(),
      child: BlocProvider(
        create: (context) {
          final UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return SecretarySaveBloc(
              model: model,
              secretaryRepository:
                  RepositoryProvider.of<SecretaryRepository>(context),
              seller: userProfile);
        },
        child: SecretarySaveView(
          model: model,
        ),
      ),
    );
  }
}

class SecretarySaveView extends StatefulWidget {
  final SecretaryModel? model;
  const SecretarySaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<SecretarySaveView> createState() => _SecretarySaveViewState();
}

class _SecretarySaveViewState extends State<SecretarySaveView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTEC = TextEditingController();
  final _nameTEC = TextEditingController();
  final _phoneTEC = TextEditingController();
  DateTime _birthday = DateTime.now();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _emailTEC.text = widget.model?.email ?? '';
    _nameTEC.text = widget.model?.name ?? '';
    _phoneTEC.text = widget.model?.phone ?? '';
    _birthday = widget.model?.birthday ?? DateTime.now();
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
            context.read<SecretarySaveBloc>().add(
                  SecretarySaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<SecretarySaveBloc>().add(
                    SecretarySaveEventFormSubmitted(
                      email: _emailTEC.text,
                      name: _nameTEC.text,
                      phone: _phoneTEC.text,
                      birthday: _birthday,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<SecretarySaveBloc, SecretarySaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == SecretarySaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == SecretarySaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<SecretarySearchBloc>()
                    .add(SecretarySearchEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<SecretarySearchBloc>()
                    .add(SecretarySearchEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == SecretarySaveStateStatus.loading) {
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
                      AppTextFormField(
                        label: 'email',
                        controller: _emailTEC,
                      ),
                      AppTextFormField(
                        label:
                            'Telefone pessoal da secretaria. Formato DDDNUMERO',
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
                      if (widget.model != null)
                        CheckboxListTile(
                          tileColor: delete ? Colors.red : null,
                          title: const Text('Apagar este cadastro ?'),
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
