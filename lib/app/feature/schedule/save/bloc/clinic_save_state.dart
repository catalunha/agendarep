import 'package:flutter/foundation.dart';

import '../../../../core/models/address_model.dart';
import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/medical_model.dart';
import '../../../../core/models/secretary_model.dart';

enum ClinicSaveStateStatus { initial, loading, success, error }

class ClinicSaveState {
  final ClinicSaveStateStatus status;
  final String? error;
  final ClinicModel? model;
  final List<SecretaryModel> secretariesOriginal;
  final List<SecretaryModel> secretariesUpdated;
  final MedicalModel? medical;
  final AddressModel? address;
  ClinicSaveState({
    required this.status,
    this.error,
    this.model,
    this.secretariesOriginal = const [],
    this.secretariesUpdated = const [],
    this.medical,
    this.address,
  });
  ClinicSaveState.initial(this.model)
      : status = ClinicSaveStateStatus.initial,
        error = '',
        medical = model?.medical,
        address = model?.address,
        secretariesOriginal = model?.secretaries ?? [],
        secretariesUpdated = model?.secretaries ?? [];
  ClinicSaveState copyWith({
    ClinicSaveStateStatus? status,
    String? error,
    ClinicModel? model,
    List<SecretaryModel>? secretariesOriginal,
    List<SecretaryModel>? secretariesUpdated,
    MedicalModel? medical,
    AddressModel? address,
  }) {
    return ClinicSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      secretariesOriginal: secretariesOriginal ?? this.secretariesOriginal,
      secretariesUpdated: secretariesUpdated ?? this.secretariesUpdated,
      medical: medical ?? this.medical,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClinicSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model &&
        listEquals(other.secretariesOriginal, secretariesOriginal) &&
        listEquals(other.secretariesUpdated, secretariesUpdated) &&
        other.medical == medical &&
        other.address == address;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        secretariesOriginal.hashCode ^
        secretariesUpdated.hashCode ^
        medical.hashCode ^
        address.hashCode;
  }
}
