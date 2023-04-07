import '../../../../core/models/cycle_model.dart';

abstract class CycleListEvent {}

class CycleListEventNextPage extends CycleListEvent {}

class CycleListEventPreviousPage extends CycleListEvent {}

class CycleListEventUpdateList extends CycleListEvent {
  final CycleModel cycleModel;
  CycleListEventUpdateList(
    this.cycleModel,
  );
}

class CycleListEventRemoveFromList extends CycleListEvent {
  final String modelId;
  CycleListEventRemoveFromList(
    this.modelId,
  );
}

class CycleListEventIsArchived extends CycleListEvent {
  final bool isArchived;
  CycleListEventIsArchived({
    this.isArchived = false,
  });
}
