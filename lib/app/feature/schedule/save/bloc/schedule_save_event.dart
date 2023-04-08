import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';

abstract class ClinicSaveEvent {}

class ClinicSaveEventDelete extends ClinicSaveEvent {}

class ClinicSaveEventFormSubmitted extends ClinicSaveEvent {
  final String? name;
  final String? room;
  final String? phone;
  ClinicSaveEventFormSubmitted({
    this.name,
    this.room,
    this.phone,
  });
}

class ClinicSaveEventAddMedical extends ClinicSaveEvent {
  final MedicalModel model;
  ClinicSaveEventAddMedical(this.model);
}

class ClinicSaveEventAddExpertise extends ClinicSaveEvent {
  final ExpertiseModel model;
  ClinicSaveEventAddExpertise(this.model);
}

class ClinicSaveEventRemoveExpertise extends ClinicSaveEvent {
  final ExpertiseModel model;
  ClinicSaveEventRemoveExpertise(this.model);
}

class ClinicSaveEventAddClinic extends ClinicSaveEvent {
  final ClinicModel model;
  ClinicSaveEventAddClinic(this.model);
}

class ClinicSaveEventRemoveClinic extends ClinicSaveEvent {
  final ClinicModel model;
  ClinicSaveEventRemoveClinic(this.model);
}
