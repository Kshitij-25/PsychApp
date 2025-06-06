// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      gender: json['gender'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      avatarPath: json['avatarPath'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      avatarData: json['avatarData'] as String?,
      dateOfBirth: _timestampToDateTime(json['dateOfBirth']),
      emergencyContact: json['emergencyContact'] as String?,
      role: json['role'] as String?,
      createdAt: _timestampToDateTime(json['createdAt']),
      updatedAt: _timestampToDateTime(json['updatedAt']),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fullName': instance.fullName,
      'gender': instance.gender,
      'phoneNumber': instance.phoneNumber,
      'avatarPath': instance.avatarPath,
      'avatarUrl': instance.avatarUrl,
      'avatarData': instance.avatarData,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'emergencyContact': instance.emergencyContact,
      'role': instance.role,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
