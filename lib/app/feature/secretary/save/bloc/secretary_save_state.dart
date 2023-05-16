import '../../../../core/models/secretary_model.dart';

enum SecretarySaveStateStatus { initial, loading, success, error }

class SecretarySaveState {
  final SecretarySaveStateStatus status;
  final String? error;
  final SecretaryModel? model;
  SecretarySaveState({
    required this.status,
    this.error,
    this.model,
  });
  SecretarySaveState.initial(this.model)
      : status = SecretarySaveStateStatus.initial,
        error = '';
  SecretarySaveState copyWith({
    SecretarySaveStateStatus? status,
    String? error,
    SecretaryModel? model,
  }) {
    return SecretarySaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SecretarySaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
