import 'package:flutter/foundation.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';

enum MedicalSaveStateStatus { initial, loading, success, error }

class MedicalSaveState {
  final MedicalSaveStateStatus status;
  final String? error;
  final MedicalModel? medicalModel;
  final List<ExpertiseModel> expertisesOriginal;
  final List<ExpertiseModel> expertisesUpdated;
  MedicalSaveState({
    required this.status,
    this.error,
    this.medicalModel,
    this.expertisesOriginal = const [],
    this.expertisesUpdated = const [],
  });
  MedicalSaveState.initial(this.medicalModel)
      : status = MedicalSaveStateStatus.initial,
        error = '',
        expertisesOriginal = medicalModel?.expertises ?? [],
        expertisesUpdated = medicalModel?.expertises ?? [];
  MedicalSaveState copyWith({
    MedicalSaveStateStatus? status,
    String? error,
    MedicalModel? medicalModel,
    List<ExpertiseModel>? expertisesOriginal,
    List<ExpertiseModel>? expertisesUpdated,
  }) {
    return MedicalSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      medicalModel: medicalModel ?? this.medicalModel,
      expertisesOriginal: expertisesOriginal ?? this.expertisesOriginal,
      expertisesUpdated: expertisesUpdated ?? this.expertisesUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalSaveState &&
        other.status == status &&
        other.error == error &&
        other.medicalModel == medicalModel &&
        listEquals(other.expertisesOriginal, expertisesOriginal) &&
        listEquals(other.expertisesUpdated, expertisesUpdated);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        medicalModel.hashCode ^
        expertisesOriginal.hashCode ^
        expertisesUpdated.hashCode;
  }
}
