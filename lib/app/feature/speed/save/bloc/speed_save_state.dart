import 'package:flutter/foundation.dart';

import '../../../../core/models/address_model.dart';
import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';
import '../../../../core/models/region_model.dart';
import '../../../../core/models/schedule_models.dart';
import '../../../../core/models/secretary_model.dart';

enum SpeedSaveStateStatus { initial, updated, loading, success, error }

class SpeedSaveState {
  final SpeedSaveStateStatus status;
  final String? error;
  final RegionModel? region;
  final AddressModel? address;
  final SecretaryModel? secretary;
  final ExpertiseModel? expertise;
  final MedicalModel? medical;
  final ClinicModel? clinic;
  final ScheduleModel? schedule;
  final List<int> mondayHours;
  final List<int> tuesdayHours;
  final List<int> wednesdayHours;
  final List<int> thursdayHours;
  final List<int> fridayHours;
  final List<int> saturdayHours;
  final List<int> sundayHours;
  SpeedSaveState({
    required this.status,
    this.error,
    this.region,
    this.address,
    this.secretary,
    this.expertise,
    this.medical,
    this.clinic,
    this.schedule,
    required this.mondayHours,
    required this.tuesdayHours,
    required this.wednesdayHours,
    required this.thursdayHours,
    required this.fridayHours,
    required this.saturdayHours,
    required this.sundayHours,
  });
  SpeedSaveState.initial()
      : status = SpeedSaveStateStatus.initial,
        error = '',
        region = null,
        address = null,
        secretary = null,
        expertise = null,
        medical = null,
        clinic = null,
        schedule = null,
        mondayHours = [],
        tuesdayHours = [],
        wednesdayHours = [],
        thursdayHours = [],
        fridayHours = [],
        saturdayHours = [],
        sundayHours = [];
  // bool regionReset = false,
  // bool addressReset = false,
  // bool secretaryReset = false,
  // bool expertiseReset = false,
  // bool medicalReset = false,
  // bool clinicReset = false,
  // bool scheduleReset = false,
  // region: regionReset ? null : region ?? this.region,
  // address: addressReset ? null : address ?? this.address,
  // secretary: secretaryReset ? null : secretary ?? this.secretary,
  // expertise: expertiseReset ? null : expertise ?? this.expertise,
  // medical: medicalReset ? null : medical ?? this.medical,
  // clinic: clinicReset ? null : clinic ?? this.clinic,
  // schedule: scheduleReset ? null : schedule ?? this.schedule,
  SpeedSaveState copyWith({
    SpeedSaveStateStatus? status,
    String? error,
    RegionModel? region,
    AddressModel? address,
    SecretaryModel? secretary,
    ExpertiseModel? expertise,
    MedicalModel? medical,
    ClinicModel? clinic,
    ScheduleModel? schedule,
    List<int>? mondayHours,
    List<int>? tuesdayHours,
    List<int>? wednesdayHours,
    List<int>? thursdayHours,
    List<int>? fridayHours,
    List<int>? saturdayHours,
    List<int>? sundayHours,
    bool regionReset = false,
    bool addressReset = false,
    bool secretaryReset = false,
    bool expertiseReset = false,
    bool medicalReset = false,
    bool clinicReset = false,
    bool scheduleReset = false,
  }) {
    return SpeedSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      region: regionReset ? null : region ?? this.region,
      address: addressReset ? null : address ?? this.address,
      secretary: secretaryReset ? null : secretary ?? this.secretary,
      expertise: expertiseReset ? null : expertise ?? this.expertise,
      medical: medicalReset ? null : medical ?? this.medical,
      clinic: clinicReset ? null : clinic ?? this.clinic,
      schedule: scheduleReset ? null : schedule ?? this.schedule,
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

    return other is SpeedSaveState &&
        other.status == status &&
        other.error == error &&
        other.region == region &&
        other.address == address &&
        other.secretary == secretary &&
        other.expertise == expertise &&
        other.medical == medical &&
        other.clinic == clinic &&
        other.schedule == schedule &&
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
        region.hashCode ^
        address.hashCode ^
        secretary.hashCode ^
        expertise.hashCode ^
        medical.hashCode ^
        clinic.hashCode ^
        schedule.hashCode ^
        mondayHours.hashCode ^
        tuesdayHours.hashCode ^
        wednesdayHours.hashCode ^
        thursdayHours.hashCode ^
        fridayHours.hashCode ^
        saturdayHours.hashCode ^
        sundayHours.hashCode;
  }

  @override
  String toString() {
    return 'SpeedSaveState(status: $status, error: $error, region: $region, address: $address, secretary: $secretary, expertise: $expertise, medical: $medical, clinic: $clinic, schedule: $schedule, mondayHours: $mondayHours, tuesdayHours: $tuesdayHours, wednesdayHours: $wednesdayHours, thursdayHours: $thursdayHours, fridayHours: $fridayHours, saturdayHours: $saturdayHours, sundayHours: $sundayHours)';
  }
}
