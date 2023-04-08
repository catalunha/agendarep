abstract class SecretaryAddEditEvent {}

class SecretaryAddEditEventDelete extends SecretaryAddEditEvent {}

class SecretaryAddEditEventFormSubmitted extends SecretaryAddEditEvent {
  final String? email;
  final String? name;
  final String? phone;
  final DateTime? birthday;
  SecretaryAddEditEventFormSubmitted({
    this.email,
    this.name,
    this.phone,
    this.birthday,
  });
}
