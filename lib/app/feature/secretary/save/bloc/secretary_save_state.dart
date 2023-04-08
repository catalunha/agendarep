import '../../../../core/models/secretary_model.dart';

enum SecretarySaveStateStatus { initial, loading, success, error }

class SecretarySaveState {
  final SecretarySaveStateStatus status;
  final String? error;
  final SecretaryModel? secretaryModel;
  SecretarySaveState({
    required this.status,
    this.error,
    this.secretaryModel,
  });
  SecretarySaveState.initial(this.secretaryModel)
      : status = SecretarySaveStateStatus.initial,
        error = '';
  SecretarySaveState copyWith({
    SecretarySaveStateStatus? status,
    String? error,
    SecretaryModel? secretaryModel,
  }) {
    return SecretarySaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      secretaryModel: secretaryModel ?? this.secretaryModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SecretarySaveState &&
        other.status == status &&
        other.error == error &&
        other.secretaryModel == secretaryModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ secretaryModel.hashCode;
  }
}
