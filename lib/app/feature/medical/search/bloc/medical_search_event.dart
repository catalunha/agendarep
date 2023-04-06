import '../../../../core/models/medical_model.dart';

abstract class MedicalSearchEvent {}

class MedicalSearchEventNextPage extends MedicalSearchEvent {}

class MedicalSearchEventPreviousPage extends MedicalSearchEvent {}

class MedicalSearchEventUpdateList extends MedicalSearchEvent {
  final MedicalModel medicalModel;
  MedicalSearchEventUpdateList(
    this.medicalModel,
  );
}

class MedicalSearchEventRemoveFromList extends MedicalSearchEvent {
  final String modelId;
  MedicalSearchEventRemoveFromList(
    this.modelId,
  );
}

class MedicalSearchEventFormSubmitted extends MedicalSearchEvent {
  final bool emailEqualsToBool;
  final String emailEqualsToString;
  final bool nameContainsBool;
  final String nameContainsString;
  final bool phoneEqualsToBool;
  final String phoneEqualsToString;
  final bool crmEqualsToBool;
  final String crmEqualsToString;
  final bool isBlockedBool;
  final bool isBlockedSelected;
  final bool birthdayEqualsToBool;
  final DateTime birthdayEqualsTo;
  MedicalSearchEventFormSubmitted({
    required this.emailEqualsToBool,
    required this.emailEqualsToString,
    required this.nameContainsBool,
    required this.nameContainsString,
    required this.phoneEqualsToBool,
    required this.phoneEqualsToString,
    required this.crmEqualsToBool,
    required this.crmEqualsToString,
    required this.isBlockedBool,
    required this.isBlockedSelected,
    required this.birthdayEqualsToBool,
    required this.birthdayEqualsTo,
  });
}
