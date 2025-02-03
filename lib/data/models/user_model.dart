import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    final String? email,
    final String? fullName,
    final String? gender,
    final String? phoneNumber,
    final String? avatarPath,
    final String? avatarUrl,
    final String? avatarData,
    final DateTime? dateOfBirth,
    final String? emergencyContact,
    final String? role,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
