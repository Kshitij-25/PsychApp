import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/adapters.dart';

part 'emergeny_contact_model.freezed.dart';
part 'emergeny_contact_model.g.dart';

@freezed
@HiveType(typeId: 1)
class EmergenyContactModel with _$EmergenyContactModel {
  factory EmergenyContactModel({
    @HiveField(0) final String? emergencyName,
    @HiveField(1) final String? emergencyRelationship,
    @HiveField(2) final String? emergencyPhone,
  }) = _EmergenyContactModel;

  factory EmergenyContactModel.fromJson(Map<String, dynamic> json) => _$EmergenyContactModelFromJson(json);
}
