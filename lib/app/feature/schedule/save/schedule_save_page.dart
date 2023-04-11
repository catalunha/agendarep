import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/clinic_model.dart';
import '../../../core/models/expertise_model.dart';
import '../../../core/models/medical_model.dart';
import '../../../core/models/schedule_models.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/clinic_repository.dart';
import '../../../core/repositories/schedule_repository.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/schedule_search_bloc.dart';
import '../search/bloc/schedule_search_event.dart';
import 'bloc/schedule_save_bloc.dart';
import 'bloc/schedule_save_event.dart';
import 'bloc/schedule_save_state.dart';

class ScheduleSavePage extends StatelessWidget {
  final ScheduleModel? model;

  const ScheduleSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ScheduleRepository(),
        ),
        RepositoryProvider(
          create: (context) => ClinicRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return ScheduleSaveBloc(
              scheduleModel: model,
              scheduleRepository:
                  RepositoryProvider.of<ScheduleRepository>(context),
              clinicRepository:
                  RepositoryProvider.of<ClinicRepository>(context),
              seller: userProfile);
        },
        child: ScheduleSaveView(
          model: model,
        ),
      ),
    );
  }
}

class ScheduleSaveView extends StatefulWidget {
  final ScheduleModel? model;
  const ScheduleSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<ScheduleSaveView> createState() => _ScheduleSaveViewState();
}

class _ScheduleSaveViewState extends State<ScheduleSaveView> {
  final _formKey = GlobalKey<FormState>();
  bool _justSchedule = false;
  final _limitedSellersTEC = TextEditingController();
  final _descriptionTEC = TextEditingController();
  bool delete = false;
  @override
  void initState() {
    super.initState();
    _limitedSellersTEC.text = widget.model?.limitedSellers?.toString() ?? "";
    _descriptionTEC.text = widget.model?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar ou Editar agenda'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<ScheduleSaveBloc>().add(
                  ScheduleSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<ScheduleSaveBloc>().add(
                    ScheduleSaveEventFormSubmitted(
                      justSchedule: _justSchedule,
                      limitedSellers: int.tryParse(_limitedSellersTEC.text),
                      description: _descriptionTEC.text,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<ScheduleSaveBloc, ScheduleSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ScheduleSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ScheduleSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<ScheduleSearchBloc>()
                    .add(ScheduleSearchEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<ScheduleSearchBloc>()
                    .add(ScheduleSearchEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == ScheduleSaveStateStatus.updated) {
            Navigator.of(context).pop();
          }
          if (state.status == ScheduleSaveStateStatus.loading) {
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
                      const Text('Selecione o médico *'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<ScheduleSaveBloc>();
                                MedicalModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/medical/select')
                                        as MedicalModel?;
                                if (result != null) {
                                  contextTemp
                                      .add(ScheduleSaveEventAddMedical(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<ScheduleSaveBloc, ScheduleSaveState>(
                            builder: (context, state) {
                              return Text('${state.medical?.name}');
                            },
                          ),
                        ],
                      ),
                      const Text('Selecione a especialidade *'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<ScheduleSaveBloc>();
                                ExpertiseModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/expertise/select')
                                        as ExpertiseModel?;
                                if (result != null) {
                                  contextTemp.add(
                                      ScheduleSaveEventAddExpertise(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<ScheduleSaveBloc, ScheduleSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.expertises
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Text('${e.name}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context
                                                  .read<ScheduleSaveBloc>()
                                                  .add(
                                                    ScheduleSaveEventRemoveExpertise(
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
                      const Text('Selecione o consultorio *'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp =
                                    context.read<ScheduleSaveBloc>();
                                ClinicModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/clinic/select')
                                        as ClinicModel?;
                                if (result != null) {
                                  contextTemp
                                      .add(ScheduleSaveEventAddClinic(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<ScheduleSaveBloc, ScheduleSaveState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.clinics
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Text('${e.name}'),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context
                                                  .read<ScheduleSaveBloc>()
                                                  .add(
                                                    ScheduleSaveEventRemoveClinic(
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
                      const Divider(height: 5),
                      const HoursInWeekday(weekday: 2),
                      const HoursInWeekday(weekday: 3),
                      const HoursInWeekday(weekday: 4),
                      const HoursInWeekday(weekday: 5),
                      const HoursInWeekday(weekday: 6),
                      const HoursInWeekday(weekday: 7),
                      const HoursInWeekday(weekday: 1),
                      CheckboxListTile(
                        // tileColor: _justSchedule ? Colors.red : null,
                        title: const Text(
                            "Só recebe representante por agendamento ?"),
                        onChanged: (value) {
                          setState(() {
                            _justSchedule = value ?? false;
                          });
                        },
                        value: _justSchedule,
                      ),
                      AppTextFormField(
                        label: 'Número limite de atendentes',
                        controller: _limitedSellersTEC,
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

class HoursInWeekday extends StatelessWidget {
  final int weekday;
  const HoursInWeekday({
    Key? key,
    required this.weekday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String weekdayName = '';
    if (weekday == 1) {
      weekdayName = 'Domingo';
    } else if (weekday == 2) {
      weekdayName = 'Segunda-feira';
    } else if (weekday == 3) {
      weekdayName = 'Terça-feira';
    } else if (weekday == 4) {
      weekdayName = 'Quarta-feira';
    } else if (weekday == 5) {
      weekdayName = 'Quinta-feira';
    } else if (weekday == 6) {
      weekdayName = 'Sexta-feira';
    } else if (weekday == 7) {
      weekdayName = 'Sábado';
    }
    return Card(
      child: Column(
        children: [
          Text(weekdayName),
          BlocBuilder<ScheduleSaveBloc, ScheduleSaveState>(
            builder: (context, state) {
              List<int> allHours = [
                6,
                7,
                8,
                9,
                10,
                11,
                12,
                13,
                14,
                15,
                16,
                17,
                18,
                19,
                20,
                21,
                22
              ];
              List<Widget> hours = [];
              Color color = Colors.black;
              for (var hour in allHours) {
                if (weekday == 2) {
                  if (state.mondayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 3) {
                  if (state.tuesdayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 4) {
                  if (state.wednesdayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 5) {
                  if (state.thursdayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 6) {
                  if (state.fridayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 7) {
                  if (state.saturdayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 1) {
                  if (state.sundayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                hours.add(CircleAvatar(
                  radius: 20,
                  backgroundColor: color,
                  child: IconButton(
                      onPressed: () {
                        context.read<ScheduleSaveBloc>().add(
                            ScheduleSaveEventUpdateHourInWeekday(
                                weekday: weekday, hour: hour));
                      },
                      icon: Text('$hour')),
                ));
              }
              return Wrap(
                children: hours,
              );
            },
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
