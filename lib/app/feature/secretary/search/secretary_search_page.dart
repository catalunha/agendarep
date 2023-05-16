import 'package:go_router/go_router.dart';

import '../../../core/models/user_profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/repositories/secretary_repository.dart';
import '../../../routes.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/secretary_search_bloc.dart';
import 'bloc/secretary_search_event.dart';
import 'bloc/secretary_search_state.dart';

class SecretarySearchPage extends StatelessWidget {
  const SecretarySearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SecretaryRepository(),
      child: BlocProvider(
        create: (context) {
          final UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return SecretarySearchBloc(
            secretaryRepository:
                RepositoryProvider.of<SecretaryRepository>(context),
            seller: userProfile,
          );
        },
        child: const SecretarySearchView(),
      ),
    );
  }
}

class SecretarySearchView extends StatefulWidget {
  const SecretarySearchView({Key? key}) : super(key: key);

  @override
  State<SecretarySearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<SecretarySearchView> {
  final _formKey = GlobalKey<FormState>();
  bool _emailEqualsToBool = false;
  bool _nameContainsBool = false;
  bool _phoneEqualsToBool = false;
  bool _birthdayDtSelected = false;
  final _emailEqualsToTEC = TextEditingController();
  final _nameContainsTEC = TextEditingController();
  final _phoneEqualsToTEC = TextEditingController();
  DateTime _birthdayDtValue = DateTime.now();

  @override
  void initState() {
    _emailEqualsToTEC.text = '';
    _nameContainsTEC.text = '';
    _phoneEqualsToTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando Secretária'),
      ),
      body: BlocListener<SecretarySearchBloc, SecretarySearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == SecretarySearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == SecretarySearchStateStatus.success) {
            Navigator.of(context).pop();
            context.goNamed(
              AppPage.secretarySearchList.name,
              extra: context,
            );
          }
          if (state.status == SecretarySearchStateStatus.loading) {
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
                .read<SecretarySearchBloc>()
                .add(SecretarySearchEventFormSubmitted(
                  emailEqualsToBool: _emailEqualsToBool,
                  emailEqualsToString: _emailEqualsToTEC.text,
                  nameContainsBool: _nameContainsBool,
                  nameContainsString: _nameContainsTEC.text,
                  phoneEqualsToBool: _phoneEqualsToBool,
                  phoneEqualsToString: _phoneEqualsToTEC.text,
                  birthdayEqualsToBool: _birthdayDtSelected,
                  birthdayEqualsTo: _birthdayDtValue,
                ));
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => BlocProvider.value(
            //       value: BlocProvider.of<SecretarySearchBloc>(context),
            //       child: const SecretarySearchListPage(),
            //     ),
            //   ),
            // );
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
