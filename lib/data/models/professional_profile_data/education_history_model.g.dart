// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EducationHistoryModelImpl _$$EducationHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EducationHistoryModelImpl(
      degree: json['degree'] as String?,
      institution: json['institution'] as String?,
      graduationYear: (json['graduationYear'] as num?)?.toInt(),
      specializations: json['specializations'] as String?,
      specializationsList: (json['specializationsList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$EducationHistoryModelImplToJson(
        _$EducationHistoryModelImpl instance) =>
    <String, dynamic>{
      'degree': instance.degree,
      'institution': instance.institution,
      'graduationYear': instance.graduationYear,
      'specializations': instance.specializations,
      'specializationsList': instance.specializationsList,
    };
