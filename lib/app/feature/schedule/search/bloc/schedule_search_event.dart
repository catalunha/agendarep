import '../../../../core/models/schedule_models.dart';

abstract class ScheduleSearchEvent {}

class ScheduleSearchEventNextPage extends ScheduleSearchEvent {}

class ScheduleSearchEventPreviousPage extends ScheduleSearchEvent {}

class ScheduleSearchEventUpdateList extends ScheduleSearchEvent {
  final ScheduleModel model;
  ScheduleSearchEventUpdateList(
    this.model,
  );
}

class ScheduleSearchEventRemoveFromList extends ScheduleSearchEvent {
  final String modelId;
  ScheduleSearchEventRemoveFromList(
    this.modelId,
  );
}

class ScheduleSearchEventFormSubmitted extends ScheduleSearchEvent {}
