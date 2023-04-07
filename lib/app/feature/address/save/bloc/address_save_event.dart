import 'package:agendarep/app/core/models/region_model.dart';

abstract class AddressSaveEvent {}

class AddressSaveEventDelete extends AddressSaveEvent {}

class AddressSaveEventFormSubmitted extends AddressSaveEvent {
  final String name;
  final String? phone;
  final String? description;
  final double? latitude;
  final double? longitude;
  final RegionModel regionModel;
  AddressSaveEventFormSubmitted({
    required this.name,
    this.phone,
    this.description,
    this.latitude,
    this.longitude,
    required this.regionModel,
  });
}
