import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

DateTime? _timestampToDateTime(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return null;
}

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    String? email,
    String? fullName,
    String? gender,
    String? phoneNumber,
    String? avatarPath,
    String? avatarUrl,
    String? avatarData,
    @JsonKey(fromJson: _timestampToDateTime) DateTime? dateOfBirth,
    String? emergencyContact,
    String? role,
    @JsonKey(fromJson: _timestampToDateTime) DateTime? createdAt,
    @JsonKey(fromJson: _timestampToDateTime) DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
