import '../../../../core/models/user_profile_model.dart';

abstract class UserProfileSearchEvent {}

class UserProfileSearchEventNextPage extends UserProfileSearchEvent {}

class UserProfileSearchEventPreviousPage extends UserProfileSearchEvent {}

class UserProfileSearchEventUpdateList extends UserProfileSearchEvent {
  final UserProfileModel userProfileModel;
  UserProfileSearchEventUpdateList(
    this.userProfileModel,
  );
}

class UserProfileSearchEventFormSubmitted extends UserProfileSearchEvent {
  final bool nameContainsBool;
  final String nameContainsString;
  final bool nicknameContainsBool;
  final String nicknameContainsString;
  final bool registerEqualToBool;
  final String registerEqualToString;
  final bool phoneEqualToBool;
  final String phoneEqualToString;
  UserProfileSearchEventFormSubmitted({
    required this.nameContainsBool,
    required this.nameContainsString,
    required this.nicknameContainsBool,
    required this.nicknameContainsString,
    required this.registerEqualToBool,
    required this.registerEqualToString,
    required this.phoneEqualToBool,
    required this.phoneEqualToString,
  });

  UserProfileSearchEventFormSubmitted copyWith({
    bool? nameContainsBool,
    String? nameContainsString,
    bool? nicknameContainsBool,
    String? nicknameContainsString,
    bool? registerEqualToBool,
    String? registerEqualToString,
    bool? phoneEqualToBool,
    String? phoneEqualToString,
  }) {
    return UserProfileSearchEventFormSubmitted(
      nameContainsBool: nameContainsBool ?? this.nameContainsBool,
      nameContainsString: nameContainsString ?? this.nameContainsString,
      nicknameContainsBool: nicknameContainsBool ?? this.nicknameContainsBool,
      nicknameContainsString:
          nicknameContainsString ?? this.nicknameContainsString,
      registerEqualToBool: registerEqualToBool ?? this.registerEqualToBool,
      registerEqualToString:
          registerEqualToString ?? this.registerEqualToString,
      phoneEqualToBool: phoneEqualToBool ?? this.phoneEqualToBool,
      phoneEqualToString: phoneEqualToString ?? this.phoneEqualToString,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileSearchEventFormSubmitted &&
        other.nameContainsBool == nameContainsBool &&
        other.nameContainsString == nameContainsString &&
        other.nicknameContainsBool == nicknameContainsBool &&
        other.nicknameContainsString == nicknameContainsString &&
        other.registerEqualToBool == registerEqualToBool &&
        other.registerEqualToString == registerEqualToString &&
        other.phoneEqualToBool == phoneEqualToBool &&
        other.phoneEqualToString == phoneEqualToString;
  }

  @override
  int get hashCode {
    return nameContainsBool.hashCode ^
        nameContainsString.hashCode ^
        nicknameContainsBool.hashCode ^
        nicknameContainsString.hashCode ^
        registerEqualToBool.hashCode ^
        registerEqualToString.hashCode ^
        phoneEqualToBool.hashCode ^
        phoneEqualToString.hashCode;
  }
}
