// import 'package:agendarep/app/feature/speed/save/bloc/speed_save_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:validatorless/validatorless.dart';

// import '../../../core/authentication/authentication.dart';
// import '../../../core/models/expertise_model.dart';
// import '../../../core/models/region_model.dart';
// import '../../../core/models/user_profile_model.dart';
// import '../../../core/repositories/region_repository.dart';
// import '../../utils/app_textformfield.dart';
// import 'bloc/speed_save_bloc.dart';
// import 'bloc/speed_save_state.dart';
// import 'comp/hours_in_weekday.dart';

// class SpeedSavePage extends StatelessWidget {
//   const SpeedSavePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider(
//       create: (context) => RegionRepository(),
//       child: BlocProvider(
//         create: (context) {
//           UserProfileModel userProfile =
//               context.read<AuthenticationBloc>().state.user!.userProfile!;

//           return SpeedSaveBloc(
//             seller: userProfile,
//             regionRepository: RepositoryProvider.of<RegionRepository>(context),
//           );
//         },
//         child: const SpeedSaveView(),
//       ),
//     );
//   }
// }

// class SpeedSaveView extends StatefulWidget {
//   const SpeedSaveView({Key? key}) : super(key: key);

//   @override
//   State<SpeedSaveView> createState() => _SpeedSaveViewState();
// }

// class _SpeedSaveViewState extends State<SpeedSaveView> {
//   final _formKey = GlobalKey<FormState>();
//   //Region
//   RegionModel? regionModel;
//   final _regionUfTEC = TextEditingController();
//   final _regionCityTEC = TextEditingController();
//   final _regionNameTEC = TextEditingController();
//   //Address
//   final _addressNameTEC = TextEditingController();
//   final _addressPhoneTEC = TextEditingController();
//   final _addressDescriptionTEC = TextEditingController();
//   //Secretary
//   final _secretaryNameTEC = TextEditingController();
//   final _secretaryPhoneTEC = TextEditingController();
//   final _secretaryEmailTEC = TextEditingController();
//   //Medical
//   final _medicalNameTEC = TextEditingController();
//   final _medicalPhoneTEC = TextEditingController();
//   final _medicalEmailTEC = TextEditingController();
//   final _medicalCrmTEC = TextEditingController();
//   //Clinic
//   final _clinicNameTEC = TextEditingController();
//   final _clinicPhoneTEC = TextEditingController();
//   final _clinicRoomTEC = TextEditingController();
//   //Schedule
//   bool _scheduleJustSchedule = false;
//   final _scheduleLimitedSellersTEC = TextEditingController();
//   // Config Speed
//   bool selectRegion = true;
//   bool selectAddress = true;
//   bool selectSecretary = true;
//   bool selectMedical = true;
//   bool selectClinic = true;
//   bool selectSchedule = true;
//   @override
//   void initState() {
//     super.initState();
//   }

//   resetTEC() {
//     // Region
//     _regionUfTEC.text = "";
//     _regionCityTEC.text = "";
//     _regionNameTEC.text = "";
//     // Address
//     _addressNameTEC.text = "";
//     _addressPhoneTEC.text = "";
//     _addressDescriptionTEC.text = "";
//     //Secretary
//     _secretaryNameTEC.text = "";
//     _secretaryPhoneTEC.text = "";
//     _secretaryEmailTEC.text = "";
//     //Medical
//     _medicalNameTEC.text = "";
//     _medicalPhoneTEC.text = "";
//     _medicalEmailTEC.text = "";
//     _medicalCrmTEC.text = "";
//     //Clinic
//     _clinicNameTEC.text = "";
//     _clinicPhoneTEC.text = "";
//     _clinicRoomTEC.text = "";
//     context.read<SpeedSaveBloc>().add(SpeedSaveEventSetRegion(null));
//     context.read<SpeedSaveBloc>().add(SpeedSaveEventSetAddress(null));
//     context.read<SpeedSaveBloc>().add(SpeedSaveEventSetSecretary(null));
//     context.read<SpeedSaveBloc>().add(SpeedSaveEventSetMedical(null));
//     context.read<SpeedSaveBloc>().add(SpeedSaveEventSetClinic(null));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Speed'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.cloud_upload),
//         onPressed: () async {
//           final formValid = _formKey.currentState?.validate() ?? false;
//           if (formValid) {
//             context.read<SpeedSaveBloc>().add(
//                   SpeedSaveEventFormSubmitted(
//                     regionUf: _regionUfTEC.text,
//                     regionCity: _regionCityTEC.text,
//                     regionName: _regionNameTEC.text,
//                   ),
//                 );
//           }
//         },
//       ),
//       body: BlocListener<SpeedSaveBloc, SpeedSaveState>(
//         listener: (context, state) async {
//           if (state.status == SpeedSaveStateStatus.error) {
//             Navigator.of(context).pop();
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
//           }
//           if (state.status == SpeedSaveStateStatus.success) {
//             Navigator.of(context).pop();
//             Navigator.of(context).pop();
//           }
//           if (state.status == SpeedSaveStateStatus.loading) {
//             await showDialog(
//               barrierDismissible: false,
//               context: context,
//               builder: (BuildContext context) {
//                 return const Center(child: CircularProgressIndicator());
//               },
//             );
//           }
//         },
//         child: Form(
//           key: _formKey,
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 600),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Text('Dados do médico'),
//                   Card(
//                     child: Column(
//                       children: [
//                         AppTextFormField(
//                           label: '* Nome',
//                           controller: _medicalNameTEC,
//                           validator: Validatorless.required(
//                               'Esta informação é obrigatória'),
//                         ),
//                         const Text('Selecione uma Especialidade'),
//                         Row(
//                           children: [
//                             IconButton(
//                                 onPressed: () async {
//                                   var contextTemp =
//                                       context.read<SpeedSaveBloc>();
//                                   ExpertiseModel? result =
//                                       await Navigator.of(context)
//                                               .pushNamed('/expertise/select')
//                                           as ExpertiseModel?;
//                                   if (result != null) {
//                                     contextTemp.add(
//                                         SpeedSaveEventSetExpertise(result));
//                                   }
//                                 },
//                                 icon: const Icon(Icons.search)),
//                             BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
//                               builder: (context, state) {
//                                 return Visibility(
//                                   visible: state.expertise != null,
//                                   child: Row(
//                                     children: [
//                                       Text('${state.expertise?.name}'),
//                                       IconButton(
//                                           onPressed: () {
//                                             context.read<SpeedSaveBloc>().add(
//                                                 SpeedSaveEventSetExpertise(
//                                                     null));
//                                           },
//                                           icon: const Icon(Icons.delete))
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(width: 15)
//                           ],
//                         ),
//                         AppTextFormField(
//                           label:
//                               'Telefone pessoal do médico. Formato DDDNUMERO',
//                           controller: _medicalPhoneTEC,
//                           validator: Validatorless.number('Apenas números.'),
//                         ),
//                         // AppTextFormField(
//                         //   label: 'email',
//                         //   controller: _medicalEmailTEC,
//                         // ),
//                         AppTextFormField(
//                           label: 'CRM',
//                           controller: _medicalCrmTEC,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Text('Dados da secretaria'),
//                   Card(
//                     child: Column(children: [
//                       AppTextFormField(
//                           label: '* Nome',
//                           controller: _secretaryNameTEC,
//                           validator: Validatorless.required(
//                               'Esta informação é obrigatória')),
//                       const Divider(height: 5),
//                       AppTextFormField(
//                           label:
//                               'Telefone pessoal da secretaria. Formato DDDNUMERO',
//                           controller: _secretaryPhoneTEC,
//                           validator: Validatorless.number('Apenas números.')),
//                     ]),
//                   ),
//                   const Text('Dados da clinica'),
//                   Card(
//                     child: Column(children: [
//                       AppTextFormField(
//                           label: '* Nome',
//                           controller: _clinicNameTEC,
//                           validator: Validatorless.required(
//                               'Esta informação é obrigatória')),
//                       const Divider(height: 5),
//                       AppTextFormField(
//                           label: 'Telefone da clinica. Formato DDDNUMERO',
//                           controller: _clinicPhoneTEC,
//                           validator: Validatorless.number('Apenas números.')),
//                       AppTextFormField(
//                         label: 'Sala',
//                         controller: _clinicRoomTEC,
//                       ),
//                       Card(
//                         color: Colors.black45,
//                         child: Column(children: [
//                           const Text('Localização da Clinica'),
//                           const Text('Selecione ou adicione uma região'),
//                           Row(
//                             children: [
//                               IconButton(
//                                   onPressed: () async {
//                                     var contextTemp =
//                                         context.read<SpeedSaveBloc>();
//                                     RegionModel? result =
//                                         await Navigator.of(context)
//                                                 .pushNamed('/region/select')
//                                             as RegionModel?;
//                                     if (result != null) {
//                                       contextTemp
//                                           .add(SpeedSaveEventSetRegion(result));
//                                     }
//                                   },
//                                   icon: const Icon(Icons.search)),
//                               BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
//                                 builder: (context, state) {
//                                   return Visibility(
//                                     visible: state.region != null,
//                                     child: Row(
//                                       children: [
//                                         Text('${state.region?.name}'),
//                                         IconButton(
//                                             onPressed: () {
//                                               context.read<SpeedSaveBloc>().add(
//                                                   SpeedSaveEventSetRegion(
//                                                       null));
//                                             },
//                                             icon: const Icon(Icons.delete))
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                           BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
//                             builder: (context, state) {
//                               return Visibility(
//                                 visible: state.region == null,
//                                 child: Column(
//                                   children: [
//                                     AppTextFormField(
//                                       label: 'Estado *',
//                                       controller: _regionUfTEC,
//                                       validator: state.region == null
//                                           ? Validatorless.required(
//                                               'Esta informação é obrigatória')
//                                           : null,
//                                     ),
//                                     AppTextFormField(
//                                       label: 'Cidade *',
//                                       controller: _regionCityTEC,
//                                       validator: state.region == null
//                                           ? Validatorless.required(
//                                               'Esta informação é obrigatória')
//                                           : null,
//                                     ),
//                                     AppTextFormField(
//                                       label:
//                                           'Nome * (Centro, Setor X, Bairro Y, Quadras A B C, etc)',
//                                       controller: _regionNameTEC,
//                                       validator: state.region == null
//                                           ? Validatorless.required(
//                                               'Esta informação é obrigatória')
//                                           : null,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ]),
//                       )
//                     ]),
//                   ),
//                   const Text('Preencher a agenda médica'),
//                   Visibility(
//                     visible: selectSchedule,
//                     child: Card(
//                       child: Column(children: [
//                         CheckboxListTile(
//                           title: const Text(
//                               "Só recebe representante por agendamento ?"),
//                           onChanged: (value) {
//                             setState(() {
//                               _scheduleJustSchedule = value ?? false;
//                             });
//                           },
//                           value: _scheduleJustSchedule,
//                         ),
//                         AppTextFormField(
//                           label: 'Número limite de atendentes',
//                           controller: _scheduleLimitedSellersTEC,
//                         ),
//                         const HoursInWeekday(weekday: 2),
//                         const HoursInWeekday(weekday: 3),
//                         const HoursInWeekday(weekday: 4),
//                         const HoursInWeekday(weekday: 5),
//                         const HoursInWeekday(weekday: 6),
//                         const HoursInWeekday(weekday: 7),
//                         const HoursInWeekday(weekday: 1),
//                       ]),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
