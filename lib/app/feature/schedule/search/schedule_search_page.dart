import 'package:agendarep/app/core/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/repositories/schedule_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/schedule_search_bloc.dart';
import 'bloc/schedule_search_event.dart';
import 'bloc/schedule_search_state.dart';
import 'list/schedule_search_list_page.dart';

class ScheduleSearchPage extends StatelessWidget {
  const ScheduleSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ScheduleRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;
          return ScheduleSearchBloc(
            scheduleRepository:
                RepositoryProvider.of<ScheduleRepository>(context),
            seller: userProfile,
          );
        },
        child: const ScheduleSearchView(),
      ),
    );
  }
}

class ScheduleSearchView extends StatefulWidget {
  const ScheduleSearchView({Key? key}) : super(key: key);

  @override
  State<ScheduleSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<ScheduleSearchView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando Agenda'),
      ),
      body: BlocListener<ScheduleSearchBloc, ScheduleSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ScheduleSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ScheduleSearchStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == ScheduleSearchStateStatus.loading) {
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
                  children: const [
                    Text('Apenas click na lupa para ver todos'),
                    SizedBox(height: 70)
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
                .read<ScheduleSearchBloc>()
                .add(ScheduleSearchEventFormSubmitted());
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ScheduleSearchBloc>(context),
                  child: const ScheduleSearchListPage(),
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
