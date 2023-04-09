import 'package:flutter/foundation.dart';

import 'package:agendarep/app/core/models/clinic_model.dart';
import 'package:agendarep/app/core/models/user_profile_model.dart';

import 'expertise_model.dart';
import 'medical_model.dart';

class ScheduleModel {
  final String? id;
  final UserProfileModel? seller;
  final MedicalModel? medical;
  final ExpertiseModel? expertise;
  final ClinicModel? clinic;
  final bool? justSchedule;
  final int? limitedSellers;
  final List<int>? mondayHours;
  final List<int>? tuesdayHours;
  final List<int>? wednesdayHours;
  final List<int>? thursdayHours;
  final List<int>? fridayHours;
  final List<int>? saturdayHours;
  final List<int>? sundayHours;
  final String? description;
  ScheduleModel({
    this.id,
    this.seller,
    this.medical,
    this.expertise,
    this.clinic,
    this.justSchedule,
    this.limitedSellers,
    this.mondayHours,
    this.tuesdayHours,
    this.wednesdayHours,
    this.thursdayHours,
    this.fridayHours,
    this.saturdayHours,
    this.sundayHours,
    this.description,
  });

  ScheduleModel copyWith({
    String? id,
    UserProfileModel? seller,
    MedicalModel? medical,
    ExpertiseModel? expertise,
    ClinicModel? clinic,
    bool? justSchedule,
    int? limitedSellers,
    List<int>? mondayHours,
    List<int>? tuesdayHours,
    List<int>? wednesdayHours,
    List<int>? thursdayHours,
    List<int>? fridayHours,
    List<int>? saturdayHours,
    List<int>? sundayHours,
    String? description,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      medical: medical ?? this.medical,
      expertise: expertise ?? this.expertise,
      clinic: clinic ?? this.clinic,
      justSchedule: justSchedule ?? this.justSchedule,
      limitedSellers: limitedSellers ?? this.limitedSellers,
      mondayHours: mondayHours ?? this.mondayHours,
      tuesdayHours: tuesdayHours ?? this.tuesdayHours,
      wednesdayHours: wednesdayHours ?? this.wednesdayHours,
      thursdayHours: thursdayHours ?? this.thursdayHours,
      fridayHours: fridayHours ?? this.fridayHours,
      saturdayHours: saturdayHours ?? this.saturdayHours,
      sundayHours: sundayHours ?? this.sundayHours,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'ScheduleModel(id: $id, seller: $seller, medical: $medical, expertise: $expertise, clinic: $clinic, justSchedule: $justSchedule, limitedSellers: $limitedSellers, mondayHours: $mondayHours, tuesdayHours: $tuesdayHours, wednesdayHours: $wednesdayHours, thursdayHours: $thursdayHours, fridayHours: $fridayHours, saturdayHours: $saturdayHours, sundayHours: $sundayHours, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleModel &&
        other.id == id &&
        other.seller == seller &&
        other.medical == medical &&
        other.expertise == expertise &&
        other.clinic == clinic &&
        other.justSchedule == justSchedule &&
        other.limitedSellers == limitedSellers &&
        listEquals(other.mondayHours, mondayHours) &&
        listEquals(other.tuesdayHours, tuesdayHours) &&
        listEquals(other.wednesdayHours, wednesdayHours) &&
        listEquals(other.thursdayHours, thursdayHours) &&
        listEquals(other.fridayHours, fridayHours) &&
        listEquals(other.saturdayHours, saturdayHours) &&
        listEquals(other.sundayHours, sundayHours) &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        seller.hashCode ^
        medical.hashCode ^
        expertise.hashCode ^
        clinic.hashCode ^
        justSchedule.hashCode ^
        limitedSellers.hashCode ^
        mondayHours.hashCode ^
        tuesdayHours.hashCode ^
        wednesdayHours.hashCode ^
        thursdayHours.hashCode ^
        fridayHours.hashCode ^
        saturdayHours.hashCode ^
        sundayHours.hashCode ^
        description.hashCode;
  }
}
