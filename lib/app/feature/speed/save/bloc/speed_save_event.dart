import '../../../../core/models/region_model.dart';

abstract class SpeedSaveEvent {}

class SpeedSaveEventFormSubmitted extends SpeedSaveEvent {
  final String? regionUf;
  final String? regionCity;
  final String? regionName;
  SpeedSaveEventFormSubmitted({
    this.regionUf,
    this.regionCity,
    this.regionName,
  });
}

class SpeedSaveEventAddRegion extends SpeedSaveEvent {
  final RegionModel? model;
  SpeedSaveEventAddRegion(this.model);
}

class SpeedSaveEventRemoveRegion extends SpeedSaveEvent {}
