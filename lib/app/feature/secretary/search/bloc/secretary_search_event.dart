import '../../../../core/models/secretary_model.dart';

abstract class SecretarySearchEvent {}

class SecretarySearchEventNextPage extends SecretarySearchEvent {}

class SecretarySearchEventPreviousPage extends SecretarySearchEvent {}

class SecretarySearchEventUpdateList extends SecretarySearchEvent {
  final SecretaryModel secretaryModel;
  SecretarySearchEventUpdateList(
    this.secretaryModel,
  );
}

class SecretarySearchEventFormSubmitted extends SecretarySearchEvent {
  final bool emailEqualsToBool;
  final String emailEqualsToString;
  final bool nameContainsBool;
  final String nameContainsString;
  final bool phoneEqualsToBool;
  final String phoneEqualsToString;
  final bool cpfEqualsToBool;
  final String cpfEqualsToString;
  final bool birthdayEqualsToBool;
  final DateTime birthdayEqualsTo;
  SecretarySearchEventFormSubmitted({
    required this.emailEqualsToBool,
    required this.emailEqualsToString,
    required this.nameContainsBool,
    required this.nameContainsString,
    required this.phoneEqualsToBool,
    required this.phoneEqualsToString,
    required this.cpfEqualsToBool,
    required this.cpfEqualsToString,
    required this.birthdayEqualsToBool,
    required this.birthdayEqualsTo,
  });
}
