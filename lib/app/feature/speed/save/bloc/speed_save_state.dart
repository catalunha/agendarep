import '../../../../core/models/region_model.dart';

enum SpeedSaveStateStatus { initial, updated, loading, success, error }

class SpeedSaveState {
  final SpeedSaveStateStatus status;
  final String? error;
  final RegionModel? region;

  SpeedSaveState({
    required this.status,
    this.error,
    this.region,
  });
  SpeedSaveState.initial()
      : status = SpeedSaveStateStatus.initial,
        error = '',
        region = null;

  SpeedSaveState copyWith({
    SpeedSaveStateStatus? status,
    String? error,
    bool regionReset = false,
    RegionModel? region,
  }) {
    return SpeedSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      region: regionReset ? null : region ?? this.region,
    );
  }

  @override
  String toString() =>
      'SpeedSaveState(status: $status, error: $error, region: $region)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpeedSaveState &&
        other.status == status &&
        other.error == error &&
        other.region == region;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ region.hashCode;
}
