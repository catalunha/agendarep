import 'package:flutter/foundation.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';

enum MedicalAddEditStateStatus { initial, loading, success, error }

class MedicalAddEditState {
  final MedicalAddEditStateStatus status;
  final String? error;
  final MedicalModel? medicalModel;
  final List<ExpertiseModel> expertisesOriginal;
  final List<ExpertiseModel> expertisesUpdated;
  MedicalAddEditState({
    required this.status,
    this.error,
    this.medicalModel,
    this.expertisesOriginal = const [],
    this.expertisesUpdated = const [],
  });
  MedicalAddEditState.initial(this.medicalModel)
      : status = MedicalAddEditStateStatus.initial,
        error = '',
        expertisesOriginal = medicalModel?.expertises ?? [],
        expertisesUpdated = medicalModel?.expertises ?? [];
  MedicalAddEditState copyWith({
    MedicalAddEditStateStatus? status,
    String? error,
    MedicalModel? medicalModel,
    List<ExpertiseModel>? expertisesOriginal,
    List<ExpertiseModel>? expertisesUpdated,
  }) {
    return MedicalAddEditState(
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

    return other is MedicalAddEditState &&
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
