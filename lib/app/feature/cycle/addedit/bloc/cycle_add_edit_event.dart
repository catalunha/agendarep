abstract class CycleAddEditEvent {}

class CycleAddEditEventDelete extends CycleAddEditEvent {}

class CycleAddEditEventFormSubmitted extends CycleAddEditEvent {
  final String? name;
  final DateTime? start;
  final DateTime? end;
  final bool? isArchived;
  CycleAddEditEventFormSubmitted({
    this.name,
    this.start,
    this.end,
    this.isArchived,
  });
}
