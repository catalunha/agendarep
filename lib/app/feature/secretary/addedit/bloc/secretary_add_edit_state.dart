import '../../../../core/models/secretary_model.dart';

enum SecretaryAddEditStateStatus { initial, loading, success, error }

class SecretaryAddEditState {
  final SecretaryAddEditStateStatus status;
  final String? error;
  final SecretaryModel? secretaryModel;
  SecretaryAddEditState({
    required this.status,
    this.error,
    this.secretaryModel,
  });
  SecretaryAddEditState.initial(this.secretaryModel)
      : status = SecretaryAddEditStateStatus.initial,
        error = '';
  SecretaryAddEditState copyWith({
    SecretaryAddEditStateStatus? status,
    String? error,
    SecretaryModel? secretaryModel,
  }) {
    return SecretaryAddEditState(
      status: status ?? this.status,
      error: error ?? this.error,
      secretaryModel: secretaryModel ?? this.secretaryModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SecretaryAddEditState &&
        other.status == status &&
        other.error == error &&
        other.secretaryModel == secretaryModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ secretaryModel.hashCode;
  }
}
