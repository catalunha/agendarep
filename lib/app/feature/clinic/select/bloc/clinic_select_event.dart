abstract class ClinicSelectEvent {}

class ClinicSelectEventNextPage extends ClinicSelectEvent {}

class ClinicSelectEventPreviousPage extends ClinicSelectEvent {}

class ClinicSelectEventStartQuery extends ClinicSelectEvent {}

class ClinicSelectEventFormSubmitted extends ClinicSelectEvent {
  final String name;
  ClinicSelectEventFormSubmitted(this.name);
}
