import 'package:agendarep/app/core/models/expertise_model.dart';

abstract class MedicalAddEditEvent {}

class MedicalAddEditEventDelete extends MedicalAddEditEvent {}

class MedicalAddEditEventFormSubmitted extends MedicalAddEditEvent {
  final String? email;
  final String? name;
  final String? phone;
  final String? crm;
  final bool? isBlocked;
  final DateTime? birthday;
  MedicalAddEditEventFormSubmitted({
    this.email,
    this.name,
    this.phone,
    this.crm,
    this.isBlocked,
    this.birthday,
  });
}

class MedicalAddEditEventAddExpertise extends MedicalAddEditEvent {
  final ExpertiseModel model;
  MedicalAddEditEventAddExpertise(
    this.model,
  );
}

class MedicalAddEditEventRemoveExpertise extends MedicalAddEditEvent {
  final ExpertiseModel expertiseModel;
  MedicalAddEditEventRemoveExpertise(
    this.expertiseModel,
  );
}
