import 'package:agendarep/app/core/models/region_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/address_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/address_repository.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/address_search_bloc.dart';
import '../search/bloc/address_search_event.dart';
import 'bloc/address_save_bloc.dart';
import 'bloc/address_save_event.dart';
import 'bloc/address_save_state.dart';

class AddressSavePage extends StatelessWidget {
  final AddressModel? model;

  const AddressSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AddressRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.userProfile!;

          return AddressSaveBloc(
              model: model,
              addressRepository:
                  RepositoryProvider.of<AddressRepository>(context),
              seller: userProfile);
        },
        child: AddressSaveView(
          model: model,
        ),
      ),
    );
  }
}

class AddressSaveView extends StatefulWidget {
  final AddressModel? model;
  const AddressSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<AddressSaveView> createState() => _AddressSaveViewState();
}

class _AddressSaveViewState extends State<AddressSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTEC = TextEditingController();
  final _phoneTEC = TextEditingController();
  final _descriptionTEC = TextEditingController();
  final _latitudeTEC = TextEditingController();
  final _longitudeTEC = TextEditingController();
  bool delete = false;
  RegionModel? regionModel;
  @override
  void initState() {
    super.initState();
    _nameTEC.text = widget.model?.name ?? "";
    _phoneTEC.text = widget.model?.phone ?? "";
    _descriptionTEC.text = widget.model?.description ?? "";
    _latitudeTEC.text = widget.model?.parseGeoPoint?.latitude.toString() ?? "0";
    _longitudeTEC.text =
        widget.model?.parseGeoPoint?.longitude.toString() ?? '0';
    regionModel = widget.model?.region;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar ou Editar endereço'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (delete) {
            context.read<AddressSaveBloc>().add(
                  AddressSaveEventDelete(),
                );
          } else if (regionModel == null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Selecione uma região.')));
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<AddressSaveBloc>().add(
                    AddressSaveEventFormSubmitted(
                      name: _nameTEC.text,
                      phone: _phoneTEC.text,
                      description: _descriptionTEC.text,
                      latitude: double.tryParse(_latitudeTEC.text),
                      longitude: double.tryParse(_longitudeTEC.text),
                      regionModel: regionModel!,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<AddressSaveBloc, AddressSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == AddressSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == AddressSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model != null) {
              if (delete) {
                context
                    .read<AddressSearchBloc>()
                    .add(AddressSearchEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<AddressSearchBloc>()
                    .add(AddressSearchEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == AddressSaveStateStatus.loading) {
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
                      const Text('Selecione uma região'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                RegionModel? result =
                                    await Navigator.of(context)
                                            .pushNamed('/region/select')
                                        as RegionModel?;
                                if (result != null) {
                                  setState(() {
                                    regionModel = result;
                                  });
                                }
                              },
                              icon: const Icon(Icons.search)),
                          Text('${regionModel?.name}'),
                          const SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                      AppTextFormField(
                        label: 'Nome *',
                        controller: _nameTEC,
                        validator: Validatorless.required('Nome é obrigatório'),
                      ),
                      const Divider(height: 5),
                      AppTextFormField(
                        label: 'Telefone. Formato DDDNUMERO',
                        controller: _phoneTEC,
                        validator: Validatorless.number('Apenas números.'),
                      ),
                      AppTextFormField(
                        label: 'Descrição',
                        controller: _descriptionTEC,
                      ),
                      Wrap(
                        children: [
                          SizedBox(
                            width: 150,
                            child: AppTextFormField(
                              label: 'Latitude',
                              controller: _latitudeTEC,
                              validator: Validatorless.numbersBetweenInterval(
                                  -90.0, 90.0, 'Latitudes entre -90 e 90.'),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: AppTextFormField(
                              label: 'Longitude',
                              controller: _longitudeTEC,
                              validator: Validatorless.numbersBetweenInterval(
                                  -180.0, 180.0, 'Longitude entre -180 e 180.'),
                            ),
                          ),
                        ],
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
