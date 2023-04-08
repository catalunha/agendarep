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
  final int? weekday;
  final List<int>? hour;
  final String? description;
  ScheduleModel({
    this.id,
    this.seller,
    this.medical,
    this.expertise,
    this.clinic,
    this.justSchedule,
    this.limitedSellers,
    this.weekday,
    this.hour,
    this.description,
  });

  ScheduleModel copyWith({
    String? id,
    UserProfileModel? seller,
    MedicalModel? medical,
    ClinicModel? clinic,
    ExpertiseModel? expertise,
    bool? justSchedule,
    int? limitedSellers,
    int? weekday,
    List<int>? hour,
    String? description,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      medical: medical ?? this.medical,
      clinic: clinic ?? this.clinic,
      expertise: expertise ?? this.expertise,
      justSchedule: justSchedule ?? this.justSchedule,
      limitedSellers: limitedSellers ?? this.limitedSellers,
      weekday: weekday ?? this.weekday,
      hour: hour ?? this.hour,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'ScheduleModel(id: $id, seller: $seller, medical: $medical, clinic: $clinic, expertise: $expertise, justSchedule: $justSchedule, limitedSellers: $limitedSellers, weekday: $weekday, hour: $hour, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleModel &&
        other.id == id &&
        other.seller == seller &&
        other.medical == medical &&
        other.clinic == clinic &&
        other.expertise == expertise &&
        other.justSchedule == justSchedule &&
        other.limitedSellers == limitedSellers &&
        other.weekday == weekday &&
        listEquals(other.hour, hour) &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        seller.hashCode ^
        medical.hashCode ^
        clinic.hashCode ^
        expertise.hashCode ^
        justSchedule.hashCode ^
        limitedSellers.hashCode ^
        weekday.hashCode ^
        hour.hashCode ^
        description.hashCode;
  }
}
