import 'package:agendarep/app/core/models/expertise_model.dart';

abstract class MedicalSaveEvent {}

class MedicalSaveEventDelete extends MedicalSaveEvent {}

class MedicalSaveEventFormSubmitted extends MedicalSaveEvent {
  final String? email;
  final String? name;
  final String? phone;
  final String? crm;
  final bool? isBlocked;
  final DateTime? birthday;
  MedicalSaveEventFormSubmitted({
    this.email,
    this.name,
    this.phone,
    this.crm,
    this.isBlocked,
    this.birthday,
  });
}

class MedicalSaveEventAddExpertise extends MedicalSaveEvent {
  final ExpertiseModel model;
  MedicalSaveEventAddExpertise(
    this.model,
  );
}

class MedicalSaveEventRemoveExpertise extends MedicalSaveEvent {
  final ExpertiseModel expertiseModel;
  MedicalSaveEventRemoveExpertise(
    this.expertiseModel,
  );
}
