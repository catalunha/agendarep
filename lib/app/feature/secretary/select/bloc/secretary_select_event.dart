abstract class SecretarySelectEvent {}

class SecretarySelectEventNextPage extends SecretarySelectEvent {}

class SecretarySelectEventPreviousPage extends SecretarySelectEvent {}

class SecretarySelectEventStartQuery extends SecretarySelectEvent {}

class SecretarySelectEventFormSubmitted extends SecretarySelectEvent {
  final String name;
  SecretarySelectEventFormSubmitted(this.name);
}
