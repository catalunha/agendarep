abstract class CycleSaveEvent {}

class CycleSaveEventDelete extends CycleSaveEvent {}

class CycleSaveEventFormSubmitted extends CycleSaveEvent {
  final String? name;
  final DateTime? start;
  final DateTime? end;
  final bool? isArchived;
  CycleSaveEventFormSubmitted({
    this.name,
    this.start,
    this.end,
    this.isArchived,
  });
}
