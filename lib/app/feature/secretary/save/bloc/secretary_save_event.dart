abstract class SecretarySaveEvent {}

class SecretarySaveEventDelete extends SecretarySaveEvent {}

class SecretarySaveEventFormSubmitted extends SecretarySaveEvent {
  final String? email;
  final String? name;
  final String? phone;
  final DateTime? birthday;
  SecretarySaveEventFormSubmitted({
    this.email,
    this.name,
    this.phone,
    this.birthday,
  });
}
