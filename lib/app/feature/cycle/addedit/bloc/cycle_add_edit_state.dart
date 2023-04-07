import '../../../../core/models/cycle_model.dart';

enum CycleAddEditStateStatus { initial, loading, success, error }

class CycleAddEditState {
  final CycleAddEditStateStatus status;
  final String? error;
  final CycleModel? cycleModel;
  CycleAddEditState({
    required this.status,
    this.error,
    this.cycleModel,
  });
  CycleAddEditState.initial(this.cycleModel)
      : status = CycleAddEditStateStatus.initial,
        error = '';
  CycleAddEditState copyWith({
    CycleAddEditStateStatus? status,
    String? error,
    CycleModel? cycleModel,
  }) {
    return CycleAddEditState(
      status: status ?? this.status,
      error: error ?? this.error,
      cycleModel: cycleModel ?? this.cycleModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CycleAddEditState &&
        other.status == status &&
        other.error == error &&
        other.cycleModel == cycleModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ cycleModel.hashCode;
  }
}
