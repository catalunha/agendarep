import 'dart:convert';

import 'user_profile_model.dart';

class CycleModel {
  final String? id;
  final UserProfileModel? seller;
  final String? name;
  final DateTime? start;
  final DateTime? end;
  final bool? isArchived;
  CycleModel({
    this.id,
    this.seller,
    this.name,
    this.start,
    this.end,
    this.isArchived,
  });

  CycleModel copyWith({
    String? id,
    UserProfileModel? seller,
    String? name,
    DateTime? start,
    DateTime? end,
    bool? isArchived,
  }) {
    return CycleModel(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      name: name ?? this.name,
      start: start ?? this.start,
      end: end ?? this.end,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (seller != null) {
      result.addAll({'seller': seller!.toMap()});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (start != null) {
      result.addAll({'start': start!.millisecondsSinceEpoch});
    }
    if (end != null) {
      result.addAll({'end': end!.millisecondsSinceEpoch});
    }
    if (isArchived != null) {
      result.addAll({'isArchived': isArchived});
    }

    return result;
  }

  factory CycleModel.fromMap(Map<String, dynamic> map) {
    return CycleModel(
      id: map['id'],
      seller: map['seller'] != null
          ? UserProfileModel.fromMap(map['seller'])
          : null,
      name: map['name'],
      start: map['start'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start'])
          : null,
      end: map['end'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end'])
          : null,
      isArchived: map['isArchived'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CycleModel.fromJson(String source) =>
      CycleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CycleModel(id: $id, seller: $seller, name: $name, start: $start, end: $end, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CycleModel &&
        other.id == id &&
        other.seller == seller &&
        other.name == name &&
        other.start == start &&
        other.end == end &&
        other.isArchived == isArchived;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        seller.hashCode ^
        name.hashCode ^
        start.hashCode ^
        end.hashCode ^
        isArchived.hashCode;
  }
}
