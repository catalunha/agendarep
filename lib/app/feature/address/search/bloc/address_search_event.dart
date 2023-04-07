import '../../../../core/models/address_model.dart';

abstract class AddressSearchEvent {}

class AddressSearchEventNextPage extends AddressSearchEvent {}

class AddressSearchEventPreviousPage extends AddressSearchEvent {}

class AddressSearchEventUpdateList extends AddressSearchEvent {
  final AddressModel model;
  AddressSearchEventUpdateList(
    this.model,
  );
}

class AddressSearchEventRemoveFromList extends AddressSearchEvent {
  final String modelId;
  AddressSearchEventRemoveFromList(
    this.modelId,
  );
}

class AddressSearchEventFormSubmitted extends AddressSearchEvent {
  final bool nameContainsBool;
  final String nameContainsString;
  final bool phoneEqualsToBool;
  final String phoneEqualsToString;
  AddressSearchEventFormSubmitted({
    required this.nameContainsBool,
    required this.nameContainsString,
    required this.phoneEqualsToBool,
    required this.phoneEqualsToString,
  });
}
