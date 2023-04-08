import '../../../../core/models/clinic_model.dart';

abstract class ClinicSearchEvent {}

class ClinicSearchEventNextPage extends ClinicSearchEvent {}

class ClinicSearchEventPreviousPage extends ClinicSearchEvent {}

class ClinicSearchEventUpdateList extends ClinicSearchEvent {
  final ClinicModel model;
  ClinicSearchEventUpdateList(this.model);
}

class ClinicSearchEventRemoveFromList extends ClinicSearchEvent {
  final String modelId;
  ClinicSearchEventRemoveFromList(this.modelId);
}

class ClinicSearchEventFormSubmitted extends ClinicSearchEvent {
  final bool nameContainsBool;
  final String nameContainsString;
  final bool phoneEqualsToBool;
  final String phoneEqualsToString;
  ClinicSearchEventFormSubmitted({
    required this.nameContainsBool,
    required this.nameContainsString,
    required this.phoneEqualsToBool,
    required this.phoneEqualsToString,
  });
}
