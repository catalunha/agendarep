abstract class MedicalSelectEvent {}

class MedicalSelectEventNextPage extends MedicalSelectEvent {}

class MedicalSelectEventPreviousPage extends MedicalSelectEvent {}

class MedicalSelectEventStartQuery extends MedicalSelectEvent {}

class MedicalSelectEventFormSubmitted extends MedicalSelectEvent {
  final String name;
  MedicalSelectEventFormSubmitted(this.name);
}
