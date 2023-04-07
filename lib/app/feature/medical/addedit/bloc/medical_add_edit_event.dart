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
  final String? description;
  MedicalAddEditEventFormSubmitted({
    this.email,
    this.name,
    this.phone,
    this.crm,
    this.isBlocked,
    this.birthday,
    this.description,
  });
}

class MedicalAddEditEventAddExpertise extends MedicalAddEditEvent {
  final ExpertiseModel expertiseModel;
  MedicalAddEditEventAddExpertise(
    this.expertiseModel,
  );
}

class MedicalAddEditEventRemoveExpertise extends MedicalAddEditEvent {
  final ExpertiseModel expertiseModel;
  MedicalAddEditEventRemoveExpertise(
    this.expertiseModel,
  );
}
