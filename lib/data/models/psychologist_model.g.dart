// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psychologist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PsychologistModelImpl _$$PsychologistModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PsychologistModelImpl(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      specialization: json['specialization'] as String?,
      ratings: (json['ratings'] as num?)?.toDouble(),
      reviews: (json['reviews'] as num?)?.toInt(),
      phoneNumber: json['phoneNumber'] as String?,
      qualification: json['qualification'] as String?,
      about: json['about'] as String?,
      publications: (json['publications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      publicationsLinks: (json['publicationsLinks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      avatarData: json['avatarData'] as String?,
      avatarPath: json['avatarPath'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      availability: (json['availability'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      expertise: (json['expertise'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      relationships: (json['relationships'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      workStudy: (json['workStudy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      happeningsInLife: (json['happeningsInLife'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      therapistGender: json['therapistGender'] as String?,
      sessionTime: json['sessionTime'] as String?,
      role: json['role'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$$PsychologistModelImplToJson(
        _$PsychologistModelImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'specialization': instance.specialization,
      'ratings': instance.ratings,
      'reviews': instance.reviews,
      'phoneNumber': instance.phoneNumber,
      'qualification': instance.qualification,
      'about': instance.about,
      'publications': instance.publications,
      'publicationsLinks': instance.publicationsLinks,
      'avatarData': instance.avatarData,
      'avatarPath': instance.avatarPath,
      'avatarUrl': instance.avatarUrl,
      'availability': instance.availability,
      'expertise': instance.expertise,
      'relationships': instance.relationships,
      'workStudy': instance.workStudy,
      'happeningsInLife': instance.happeningsInLife,
      'therapistGender': instance.therapistGender,
      'sessionTime': instance.sessionTime,
      'role': instance.role,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };
