import 'package:agendarep/app/core/models/user_profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/repositories/medical_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/medical_search_bloc.dart';
import 'bloc/medical_search_event.dart';
import 'bloc/medical_search_state.dart';
import 'list/medical_search_list_page.dart';

class MedicalSearchPage extends StatelessWidget {
  const MedicalSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MedicalRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return MedicalSearchBloc(
            medicalRepository:
                RepositoryProvider.of<MedicalRepository>(context),
            seller: userProfile,
          );
        },
        child: const MedicalSearchView(),
      ),
    );
  }
}

class MedicalSearchView extends StatefulWidget {
  const MedicalSearchView({Key? key}) : super(key: key);

  @override
  State<MedicalSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<MedicalSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool _emailEqualsToBool = false;
  bool _nameContainsBool = false;
  bool _phoneEqualsToBool = false;
  bool _crmEqualsToBool = false;
  bool _isBlockedBool = false;
  bool _birthdayDtSelected = false;
  final _emailEqualsToTEC = TextEditingController();
  final _nameContainsTEC = TextEditingController();
  final _phoneEqualsToTEC = TextEditingController();
  final _crmEqualsToTEC = TextEditingController();
  bool _isBlockedSelected = false;
  DateTime _birthdayDtValue = DateTime.now();

  @override
  void initState() {
    _emailEqualsToTEC.text = '';
    _nameContainsTEC.text = '';
    _phoneEqualsToTEC.text = '';
    _crmEqualsToTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando Médico'),
      ),
      body: BlocListener<MedicalSearchBloc, MedicalSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == MedicalSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == MedicalSearchStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == MedicalSearchStateStatus.loading) {
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          const Text('por email'),
                          Row(
                            children: [
                              Checkbox(
                                value: _emailEqualsToBool,
                                onChanged: (value) {
                                  setState(() {
                                    _emailEqualsToBool = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'igual a',
                                  controller: _emailEqualsToTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por nome'),
                          Row(
                            children: [
                              Checkbox(
                                value: _nameContainsBool,
                                onChanged: (value) {
                                  setState(() {
                                    _nameContainsBool = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contém',
                                  controller: _nameContainsTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Telefone'),
                          Row(
                            children: [
                              Checkbox(
                                value: _phoneEqualsToBool,
                                onChanged: (value) {
                                  setState(() {
                                    _phoneEqualsToBool = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'igual a',
                                  controller: _phoneEqualsToTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por CRM'),
                          Row(
                            children: [
                              Checkbox(
                                value: _crmEqualsToBool,
                                onChanged: (value) {
                                  setState(() {
                                    _crmEqualsToBool = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'igual a',
                                  controller: _crmEqualsToTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Bloqueio'),
                          Row(
                            children: [
                              Checkbox(
                                value: _isBlockedBool,
                                onChanged: (value) {
                                  setState(() {
                                    _isBlockedBool = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  tileColor:
                                      _isBlockedSelected ? Colors.red : null,
                                  title: const Text("Bloquear este cadastro ?"),
                                  onChanged: (value) {
                                    setState(() {
                                      _isBlockedSelected = value ?? false;
                                    });
                                  },
                                  value: _isBlockedSelected,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Data de aniversário'),
                          Row(
                            children: [
                              Checkbox(
                                value: _birthdayDtSelected,
                                onChanged: (value) {
                                  setState(() {
                                    _birthdayDtSelected = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 300,
                                  height: 100,
                                  child: CupertinoDatePicker(
                                    initialDateTime: _birthdayDtValue,
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (DateTime newDate) {
                                      print(newDate);
                                      _birthdayDtValue = newDate;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Executar busca',
        child: const Icon(AppIconData.search),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context
                .read<MedicalSearchBloc>()
                .add(MedicalSearchEventFormSubmitted(
                  emailEqualsToBool: _emailEqualsToBool,
                  emailEqualsToString: _emailEqualsToTEC.text,
                  nameContainsBool: _nameContainsBool,
                  nameContainsString: _nameContainsTEC.text,
                  phoneEqualsToBool: _phoneEqualsToBool,
                  phoneEqualsToString: _phoneEqualsToTEC.text,
                  crmEqualsToBool: _crmEqualsToBool,
                  crmEqualsToString: _crmEqualsToTEC.text,
                  isBlockedBool: _isBlockedBool,
                  isBlockedSelected: _isBlockedSelected,
                  birthdayEqualsToBool: _birthdayDtSelected,
                  birthdayEqualsTo: _birthdayDtValue,
                ));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<MedicalSearchBloc>(context),
                  child: const MedicalSearchListPage(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class SearchCardText extends StatelessWidget {
  final String title;
  final String label;
  final bool isSelected;
  final Function(bool?)? selectedOnChanged;
  final TextEditingController controller;
  const SearchCardText({
    super.key,
    required this.title,
    required this.label,
    required this.isSelected,
    required this.controller,
    this.selectedOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: selectedOnChanged,
              ),
              Expanded(
                child: AppTextFormField(
                  label: label,
                  controller: controller,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchCardBool extends StatelessWidget {
  final String title;
  final String label;
  final bool isSelected;
  final Function(bool?)? selectedOnChanged;
  final bool isSelectedValue;
  final Function(bool?)? selectedValueOnChanged;
  const SearchCardBool({
    super.key,
    required this.title,
    required this.label,
    required this.isSelected,
    this.selectedOnChanged,
    required this.isSelectedValue,
    this.selectedValueOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: selectedOnChanged,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12,
                  ),
                  child: Row(
                    children: [
                      Text(label),
                      Checkbox(
                        value: isSelectedValue,
                        onChanged: selectedValueOnChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
