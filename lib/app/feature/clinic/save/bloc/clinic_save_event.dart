import 'package:agendarep/app/core/models/secretary_model.dart';

import '../../../../core/models/address_model.dart';
import '../../../../core/models/medical_model.dart';

abstract class ClinicSaveEvent {}

class ClinicSaveEventDelete extends ClinicSaveEvent {}

class ClinicSaveEventFormSubmitted extends ClinicSaveEvent {
  final String? name;
  final String? room;
  final String? phone;
  final String? description;
  ClinicSaveEventFormSubmitted({
    this.name,
    this.room,
    this.phone,
    this.description,
  });
}

class ClinicSaveEventAddSecretary extends ClinicSaveEvent {
  final SecretaryModel model;
  ClinicSaveEventAddSecretary(this.model);
}

class ClinicSaveEventRemoveSecretary extends ClinicSaveEvent {
  final SecretaryModel model;
  ClinicSaveEventRemoveSecretary(this.model);
}

class ClinicSaveEventAddMedical extends ClinicSaveEvent {
  final MedicalModel model;
  ClinicSaveEventAddMedical(this.model);
}

class ClinicSaveEventAddAddress extends ClinicSaveEvent {
  final AddressModel model;
  ClinicSaveEventAddAddress(this.model);
}
