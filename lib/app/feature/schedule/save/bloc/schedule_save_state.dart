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
  final List<int> mondayHours;
  final List<int> tuesdayHours;
  final List<int> wednesdayHours;
  final List<int> thursdayHours;
  final List<int> fridayHours;
  final List<int> saturdayHours;
  final List<int> sundayHours;
  ScheduleSaveState({
    required this.status,
    this.error,
    this.model,
    this.medical,
    required this.expertises,
    required this.clinics,
    required this.mondayHours,
    required this.tuesdayHours,
    required this.wednesdayHours,
    required this.thursdayHours,
    required this.fridayHours,
    required this.saturdayHours,
    required this.sundayHours,
  });
  ScheduleSaveState.initial(this.model)
      : status = ScheduleSaveStateStatus.initial,
        error = '',
        medical = model?.medical,
        expertises = model?.expertise != null ? [model!.expertise!] : [],
        clinics = model?.clinic != null ? [model!.clinic!] : [],
        mondayHours = model?.mondayHours ?? [],
        tuesdayHours = model?.tuesdayHours ?? [],
        wednesdayHours = model?.wednesdayHours ?? [],
        thursdayHours = model?.thursdayHours ?? [],
        fridayHours = model?.fridayHours ?? [],
        saturdayHours = model?.saturdayHours ?? [],
        sundayHours = model?.sundayHours ?? [];
  ScheduleSaveState copyWith({
    ScheduleSaveStateStatus? status,
    String? error,
    ScheduleModel? model,
    MedicalModel? medical,
    List<ExpertiseModel>? expertises,
    List<ClinicModel>? clinics,
    List<int>? mondayHours,
    List<int>? tuesdayHours,
    List<int>? wednesdayHours,
    List<int>? thursdayHours,
    List<int>? fridayHours,
    List<int>? saturdayHours,
    List<int>? sundayHours,
  }) {
    return ScheduleSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      medical: medical ?? this.medical,
      expertises: expertises ?? this.expertises,
      clinics: clinics ?? this.clinics,
      mondayHours: mondayHours ?? this.mondayHours,
      tuesdayHours: tuesdayHours ?? this.tuesdayHours,
      wednesdayHours: wednesdayHours ?? this.wednesdayHours,
      thursdayHours: thursdayHours ?? this.thursdayHours,
      fridayHours: fridayHours ?? this.fridayHours,
      saturdayHours: saturdayHours ?? this.saturdayHours,
      sundayHours: sundayHours ?? this.sundayHours,
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
        listEquals(other.clinics, clinics) &&
        listEquals(other.mondayHours, mondayHours) &&
        listEquals(other.tuesdayHours, tuesdayHours) &&
        listEquals(other.wednesdayHours, wednesdayHours) &&
        listEquals(other.thursdayHours, thursdayHours) &&
        listEquals(other.fridayHours, fridayHours) &&
        listEquals(other.saturdayHours, saturdayHours) &&
        listEquals(other.sundayHours, sundayHours);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        medical.hashCode ^
        expertises.hashCode ^
        clinics.hashCode ^
        mondayHours.hashCode ^
        tuesdayHours.hashCode ^
        wednesdayHours.hashCode ^
        thursdayHours.hashCode ^
        fridayHours.hashCode ^
        saturdayHours.hashCode ^
        sundayHours.hashCode;
  }
}
