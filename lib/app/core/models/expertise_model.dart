import 'dart:convert';

class ExpertiseModel {
  final String? id;
  final String? code;
  final String? name;
  ExpertiseModel({
    this.id,
    this.code,
    this.name,
  });

  ExpertiseModel copyWith({
    String? id,
    String? code,
    String? name,
  }) {
    return ExpertiseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (code != null) {
      result.addAll({'code': code});
    }
    if (name != null) {
      result.addAll({'name': name});
    }

    return result;
  }

  factory ExpertiseModel.fromMap(Map<String, dynamic> map) {
    return ExpertiseModel(
      id: map['id'],
      code: map['code'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpertiseModel.fromJson(String source) =>
      ExpertiseModel.fromMap(json.decode(source));

  @override
  String toString() => 'ExpertiseModel(id: $id, code: $code, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpertiseModel &&
        other.id == id &&
        other.code == code &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ code.hashCode ^ name.hashCode;
}
