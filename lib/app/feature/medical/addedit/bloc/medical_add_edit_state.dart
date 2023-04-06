import '../../../../core/models/medical_model.dart';

enum MedicalAddEditStateStatus { initial, loading, success, error }

class MedicalAddEditState {
  final MedicalAddEditStateStatus status;
  final String? error;
  final MedicalModel? medicalModel;
  MedicalAddEditState({
    required this.status,
    this.error,
    this.medicalModel,
  });
  MedicalAddEditState.initial(this.medicalModel)
      : status = MedicalAddEditStateStatus.initial,
        error = '';
  MedicalAddEditState copyWith({
    MedicalAddEditStateStatus? status,
    String? error,
    MedicalModel? medicalModel,
  }) {
    return MedicalAddEditState(
      status: status ?? this.status,
      error: error ?? this.error,
      medicalModel: medicalModel ?? this.medicalModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalAddEditState &&
        other.status == status &&
        other.error == error &&
        other.medicalModel == medicalModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ medicalModel.hashCode;
  }
}
