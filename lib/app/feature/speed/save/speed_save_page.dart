import 'package:agendarep/app/feature/speed/save/bloc/speed_save_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/region_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/region_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/speed_save_bloc.dart';
import 'bloc/speed_save_state.dart';
import 'comp/hours_in_weekday.dart';
import 'comp/speed_address.dart';
import 'comp/speed_clinic.dart';
import 'comp/speed_medical.dart';
import 'comp/speed_region.dart';
import 'comp/speed_secretary.dart';

class SpeedSavePage extends StatelessWidget {
  const SpeedSavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RegionRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return SpeedSaveBloc(
            seller: userProfile,
            regionRepository: RepositoryProvider.of<RegionRepository>(context),
          );
        },
        child: const SpeedSaveView(),
      ),
    );
  }
}

class SpeedSaveView extends StatefulWidget {
  const SpeedSaveView({Key? key}) : super(key: key);

  @override
  State<SpeedSaveView> createState() => _SpeedSaveViewState();
}

class _SpeedSaveViewState extends State<SpeedSaveView> {
  final _formKey = GlobalKey<FormState>();
  //Region
  RegionModel? regionModel;
  final _regionUfTEC = TextEditingController();
  final _regionCityTEC = TextEditingController();
  final _regionNameTEC = TextEditingController();
  //Address
  final _addressNameTEC = TextEditingController();
  final _addressPhoneTEC = TextEditingController();
  final _addressDescriptionTEC = TextEditingController();
  //Secretary
  final _secretaryNameTEC = TextEditingController();
  final _secretaryPhoneTEC = TextEditingController();
  final _secretaryEmailTEC = TextEditingController();
  //Medical
  final _medicalNameTEC = TextEditingController();
  final _medicalPhoneTEC = TextEditingController();
  final _medicalEmailTEC = TextEditingController();
  final _medicalCrmTEC = TextEditingController();
  //Clinic
  final _clinicNameTEC = TextEditingController();
  final _clinicPhoneTEC = TextEditingController();
  final _clinicRoomTEC = TextEditingController();
  //Schedule
  bool _scheduleJustSchedule = false;
  final _scheduleLimitedSellersTEC = TextEditingController();
  // Config Speed
  bool selectRegion = true;
  bool selectAddress = true;
  bool selectSecretary = true;
  bool selectMedical = true;
  bool selectClinic = true;
  bool selectSchedule = true;
  @override
  void initState() {
    super.initState();
  }

  resetTEC() {
    // Region
    _regionUfTEC.text = "";
    _regionCityTEC.text = "";
    _regionNameTEC.text = "";
    // Address
    _addressNameTEC.text = "";
    _addressPhoneTEC.text = "";
    _addressDescriptionTEC.text = "";
    //Secretary
    _secretaryNameTEC.text = "";
    _secretaryPhoneTEC.text = "";
    _secretaryEmailTEC.text = "";
    //Medical
    _medicalNameTEC.text = "";
    _medicalPhoneTEC.text = "";
    _medicalEmailTEC.text = "";
    _medicalCrmTEC.text = "";
    //Clinic
    _clinicNameTEC.text = "";
    _clinicPhoneTEC.text = "";
    _clinicRoomTEC.text = "";
    context.read<SpeedSaveBloc>().add(SpeedSaveEventSetRegion(null));
    context.read<SpeedSaveBloc>().add(SpeedSaveEventSetAddress(null));
    context.read<SpeedSaveBloc>().add(SpeedSaveEventSetSecretary(null));
    context.read<SpeedSaveBloc>().add(SpeedSaveEventSetMedical(null));
    context.read<SpeedSaveBloc>().add(SpeedSaveEventSetClinic(null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<SpeedSaveBloc>().add(
                  SpeedSaveEventFormSubmitted(
                    regionUf: _regionUfTEC.text,
                    regionCity: _regionCityTEC.text,
                    regionName: _regionNameTEC.text,
                  ),
                );
          }
        },
      ),
      body: BlocListener<SpeedSaveBloc, SpeedSaveState>(
        listener: (context, state) async {
          if (state.status == SpeedSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == SpeedSaveStateStatus.success) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
          if (state.status == SpeedSaveStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('CADASTRANDO MÉDICO'),
                  Visibility(
                    visible: selectMedical,
                    child: SpeedMedical(
                        medicalNameTEC: _medicalNameTEC,
                        medicalPhoneTEC: _medicalPhoneTEC,
                        medicalEmailTEC: _medicalEmailTEC,
                        medicalCrmTEC: _medicalCrmTEC),
                  ),
                  const Text('CADASTRANDO SECRETARIA'),
                  Visibility(
                    visible: selectSecretary,
                    child: SpeedSecretary(
                        secretaryNameTEC: _secretaryNameTEC,
                        secretaryPhoneTEC: _secretaryPhoneTEC,
                        secretaryEmailTEC: _secretaryEmailTEC),
                  ),
                  const Text('CADASTRANDO CLÍNICA'),
                  Visibility(
                      visible: selectClinic,
                      child: SpeedClinic(
                          clinicNameTEC: _clinicNameTEC,
                          clinicPhoneTEC: _clinicPhoneTEC,
                          clinicRoomTEC: _clinicRoomTEC)),
                  const Text('CADASTRANDO ENDEREÇO'),
                  Visibility(
                    visible: selectAddress,
                    child: SpeedAddress(
                        addressNameTEC: _addressNameTEC,
                        addressPhoneTEC: _addressPhoneTEC,
                        addressDescriptionTEC: _addressDescriptionTEC),
                  ),
                  const Text('CADASTRANDO REGIÃO'),
                  Visibility(
                    visible: selectRegion,
                    child: SpeedRegion(
                        regionUfTEC: _regionUfTEC,
                        regionCityTEC: _regionCityTEC,
                        regionNameTEC: _regionNameTEC),
                  ),
                  const Text('CADASTRANDO AGENDA'),
                  Visibility(
                    visible: selectSchedule,
                    child: Card(
                      child: Column(children: [
                        const Text('Preencher a agenda médica'),
                        CheckboxListTile(
                          title: const Text(
                              "Só recebe representante por agendamento ?"),
                          onChanged: (value) {
                            setState(() {
                              _scheduleJustSchedule = value ?? false;
                            });
                          },
                          value: _scheduleJustSchedule,
                        ),
                        AppTextFormField(
                          label: 'Número limite de atendentes',
                          controller: _scheduleLimitedSellersTEC,
                        ),
                        const HoursInWeekday(weekday: 2),
                        const HoursInWeekday(weekday: 3),
                        const HoursInWeekday(weekday: 4),
                        const HoursInWeekday(weekday: 5),
                        const HoursInWeekday(weekday: 6),
                        const HoursInWeekday(weekday: 7),
                        const HoursInWeekday(weekday: 1),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
