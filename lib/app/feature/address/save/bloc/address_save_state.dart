import '../../../../core/models/address_model.dart';

enum AddressSaveStateStatus { initial, loading, success, error }

class AddressSaveState {
  final AddressSaveStateStatus status;
  final String? error;
  final AddressModel? model;
  AddressSaveState({
    required this.status,
    this.error,
    this.model,
  });
  AddressSaveState.initial(this.model)
      : status = AddressSaveStateStatus.initial,
        error = '';
  AddressSaveState copyWith({
    AddressSaveStateStatus? status,
    String? error,
    AddressModel? model,
  }) {
    return AddressSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
