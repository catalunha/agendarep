import 'package:flutter/foundation.dart';

import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';
import '../../../../core/models/schedule_models.dart';

enum ScheduleSaveStateStatus { initial, loading, success, error }

class ScheduleSaveState {
  final ScheduleSaveStateStatus status;
  final String? error;
  final ScheduleModel? model;
  final MedicalModel? medical;
  final List<ExpertiseModel> expertises;
  final List<ClinicModel> clinics;
  ScheduleSaveState({
    required this.status,
    this.error,
    this.model,
    this.medical,
    required this.expertises,
    required this.clinics,
  });
  ScheduleSaveState.initial(this.model)
      : status = ScheduleSaveStateStatus.initial,
        error = '',
        medical = model?.medical,
        expertises = model?.expertise != null
            ? [model!.expertise!]
            : model?.medical?.expertises ?? [],
        clinics = model?.clinic != null ? [model!.clinic!] : [];
  ScheduleSaveState copyWith({
    ScheduleSaveStateStatus? status,
    String? error,
    ScheduleModel? model,
    MedicalModel? medical,
    List<ExpertiseModel>? expertises,
    List<ClinicModel>? clinics,
  }) {
    return ScheduleSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      medical: medical ?? this.medical,
      expertises: expertises ?? this.expertises,
      clinics: clinics ?? this.clinics,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model &&
        other.medical == medical &&
        listEquals(other.expertises, expertises) &&
        listEquals(other.clinics, clinics);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        medical.hashCode ^
        expertises.hashCode ^
        clinics.hashCode;
  }
}
