import '../../../../core/models/cycle_model.dart';

enum CycleSaveStateStatus { initial, loading, success, error }

class CycleSaveState {
  final CycleSaveStateStatus status;
  final String? error;
  final CycleModel? cycleModel;
  CycleSaveState({
    required this.status,
    this.error,
    this.cycleModel,
  });
  CycleSaveState.initial(this.cycleModel)
      : status = CycleSaveStateStatus.initial,
        error = '';
  CycleSaveState copyWith({
    CycleSaveStateStatus? status,
    String? error,
    CycleModel? cycleModel,
  }) {
    return CycleSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      cycleModel: cycleModel ?? this.cycleModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CycleSaveState &&
        other.status == status &&
        other.error == error &&
        other.cycleModel == cycleModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ cycleModel.hashCode;
  }
}
