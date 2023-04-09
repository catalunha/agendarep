import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';

abstract class ScheduleSaveEvent {}

class ScheduleSaveEventDelete extends ScheduleSaveEvent {}

class ScheduleSaveEventFormSubmitted extends ScheduleSaveEvent {
  final bool? justSchedule;
  final int? limitedSellers;
  final String? description;
  ScheduleSaveEventFormSubmitted({
    this.justSchedule,
    this.limitedSellers,
    this.description,
  });
}

class ScheduleSaveEventAddMedical extends ScheduleSaveEvent {
  final MedicalModel model;
  ScheduleSaveEventAddMedical(this.model);
}

class ScheduleSaveEventAddExpertise extends ScheduleSaveEvent {
  final ExpertiseModel model;
  ScheduleSaveEventAddExpertise(this.model);
}

class ScheduleSaveEventRemoveExpertise extends ScheduleSaveEvent {
  final ExpertiseModel model;
  ScheduleSaveEventRemoveExpertise(this.model);
}

class ScheduleSaveEventAddClinic extends ScheduleSaveEvent {
  final ClinicModel model;
  ScheduleSaveEventAddClinic(this.model);
}

class ScheduleSaveEventRemoveClinic extends ScheduleSaveEvent {
  final ClinicModel model;
  ScheduleSaveEventRemoveClinic(this.model);
}

class ScheduleSaveEventUpdateHourInWeekday extends ScheduleSaveEvent {
  final int weekday;
  final int hour;
  ScheduleSaveEventUpdateHourInWeekday(
    this.weekday,
    this.hour,
  );
}
