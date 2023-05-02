import '../../../../core/models/address_model.dart';
import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';
import '../../../../core/models/region_model.dart';
import '../../../../core/models/secretary_model.dart';

abstract class SpeedSaveEvent {}

class SpeedSaveEventFormSubmitted extends SpeedSaveEvent {
  final String? regionUf;
  final String? regionCity;
  final String? regionName;
  final String? addressName;
  final String? addressPhone;
  final String? addressDescription;
  SpeedSaveEventFormSubmitted({
    this.regionUf,
    this.regionCity,
    this.regionName,
    this.addressName,
    this.addressPhone,
    this.addressDescription,
  });
}

class SpeedSaveEventSetRegion extends SpeedSaveEvent {
  final RegionModel? model;
  SpeedSaveEventSetRegion(this.model);
}

class SpeedSaveEventSetAddress extends SpeedSaveEvent {
  final AddressModel? model;
  SpeedSaveEventSetAddress(this.model);
}

class SpeedSaveEventSetSecretary extends SpeedSaveEvent {
  final SecretaryModel? model;
  SpeedSaveEventSetSecretary(this.model);
}

class SpeedSaveEventSetMedical extends SpeedSaveEvent {
  final MedicalModel? model;
  SpeedSaveEventSetMedical(this.model);
}

class SpeedSaveEventSetExpertise extends SpeedSaveEvent {
  final ExpertiseModel? model;
  SpeedSaveEventSetExpertise(this.model);
}

class SpeedSaveEventSetClinic extends SpeedSaveEvent {
  final ClinicModel? model;
  SpeedSaveEventSetClinic(this.model);
}

class SpeedSaveEventUpdateHourInWeekday extends SpeedSaveEvent {
  final int weekday;
  final int hour;
  SpeedSaveEventUpdateHourInWeekday({
    required this.weekday,
    required this.hour,
  });
}
