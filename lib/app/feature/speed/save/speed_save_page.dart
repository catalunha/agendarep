import 'package:agendarep/app/feature/speed/save/bloc/speed_save_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/region_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/region_repository.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/speed_save_bloc.dart';
import 'bloc/speed_save_state.dart';

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
  final _secretaryEmailTEC = TextEditingController();
  final _secretaryNameTEC = TextEditingController();
  final _secretaryPhoneTEC = TextEditingController();
  final DateTime _secretaryBirthday = DateTime.now();
  //Medical
  final _medicalEmailTEC = TextEditingController();
  final _medicalNameTEC = TextEditingController();
  final _medicalPhoneTEC = TextEditingController();
  final _medicalCrmTEC = TextEditingController();
  final DateTime _medicalBirthday = DateTime.now();
  //Clinic
  final _ClinicNameTEC = TextEditingController();
  final _ClinicRoomTEC = TextEditingController();
  final _ClinicPhoneTEC = TextEditingController();
  //Schedule
  final bool _ScheduleJustSchedule = false;
  final _ScheduleLimitedSellersTEC = TextEditingController();
  @override
  void initState() {
    super.initState();
    //Region
    // _regionUfTEC.text = "";
    // _regionCityTEC.text = "";
    // _regionNameTEC.text = "";
    //Address
    // _addressNameTEC.text = "";
    // _addressPhoneTEC.text = "";
    // _addressDescriptionTEC.text = "";
    //Secretary
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
            Navigator.of(context).pop();
          }
        },
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: Column(children: [
                      const Text('Selecione ou adicione uma região'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var contextTemp = context.read<SpeedSaveBloc>();
                                RegionModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/region/select')
                                        as RegionModel?;
                                print(result);
                                if (result != null) {
                                  contextTemp
                                      .add(SpeedSaveEventAddRegion(result));
                                }
                              },
                              icon: const Icon(Icons.search)),
                          BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
                            builder: (context, state) {
                              return Visibility(
                                visible: state.region != null,
                                child: Row(
                                  children: [
                                    Text('${state.region?.name}'),
                                    IconButton(
                                        onPressed: () {
                                          context.read<SpeedSaveBloc>().add(
                                              SpeedSaveEventRemoveRegion());
                                        },
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
                        builder: (context, state) {
                          return Visibility(
                            visible: state.region == null,
                            child: Column(
                              children: [
                                AppTextFormField(
                                  label: 'Estado *',
                                  controller: _regionUfTEC,
                                  validator: state.region == null
                                      ? Validatorless.required(
                                          'Este valor é obrigatório')
                                      : null,
                                ),
                                AppTextFormField(
                                  label: 'Cidade *',
                                  controller: _regionCityTEC,
                                  validator: state.region == null
                                      ? Validatorless.required(
                                          'Este valor é obrigatório')
                                      : null,
                                ),
                                AppTextFormField(
                                  label:
                                      'Nome * (Centro, Setor X, Bairro Y, Quadras A B C, etc)',
                                  controller: _regionNameTEC,
                                  validator: state.region == null
                                      ? Validatorless.required(
                                          'Este valor é obrigatório')
                                      : null,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
