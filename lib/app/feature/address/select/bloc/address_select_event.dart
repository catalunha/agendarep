abstract class AddressSelectEvent {}

class AddressSelectEventNextPage extends AddressSelectEvent {}

class AddressSelectEventPreviousPage extends AddressSelectEvent {}

class AddressSelectEventStartQuery extends AddressSelectEvent {}

class AddressSelectEventFormSubmitted extends AddressSelectEvent {
  final String name;
  AddressSelectEventFormSubmitted(this.name);
}
