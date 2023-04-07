import '../../../../core/models/region_model.dart';

abstract class RegionListEvent {}

class RegionListEventNextPage extends RegionListEvent {}

class RegionListEventPreviousPage extends RegionListEvent {}

class RegionListEventUpdateList extends RegionListEvent {
  final RegionModel model;
  RegionListEventUpdateList(
    this.model,
  );
}

class RegionListEventRemoveFromList extends RegionListEvent {
  final String modelId;
  RegionListEventRemoveFromList(
    this.modelId,
  );
}

class RegionListEventList extends RegionListEvent {}
