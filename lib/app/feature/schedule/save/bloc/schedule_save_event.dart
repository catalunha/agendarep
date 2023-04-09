import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';

abstract class ScheduleSaveEvent {}

class ScheduleSaveEventDelete extends ScheduleSaveEvent {}

class ScheduleSaveEventFormSubmitted extends ScheduleSaveEvent {
  final bool? justSchedule;
  final int? limitedSellers;
  final int? weekday;
  final String? description;
  ScheduleSaveEventFormSubmitted({
    this.justSchedule,
    this.limitedSellers,
    this.weekday,
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

class ScheduleSaveEventAddHour extends ScheduleSaveEvent {
  final int hour;
  ScheduleSaveEventAddHour(this.hour);
}

class ScheduleSaveEventRemoveHour extends ScheduleSaveEvent {
  final int hour;
  ScheduleSaveEventRemoveHour(this.hour);
}
