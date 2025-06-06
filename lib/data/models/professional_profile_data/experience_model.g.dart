// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExperienceModelImpl _$$ExperienceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExperienceModelImpl(
      yearsExperience: (json['yearsExperience'] as num?)?.toInt(),
      expertiseAreas: (json['expertiseAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preferredAgeGroups: (json['preferredAgeGroups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      languagesSpoken: (json['languagesSpoken'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      offersCouplesTherapy: json['offersCouplesTherapy'] as bool?,
      offersGroupTherapy: json['offersGroupTherapy'] as bool?,
    );

Map<String, dynamic> _$$ExperienceModelImplToJson(
        _$ExperienceModelImpl instance) =>
    <String, dynamic>{
      'yearsExperience': instance.yearsExperience,
      'expertiseAreas': instance.expertiseAreas,
      'preferredAgeGroups': instance.preferredAgeGroups,
      'languagesSpoken': instance.languagesSpoken,
      'offersCouplesTherapy': instance.offersCouplesTherapy,
      'offersGroupTherapy': instance.offersGroupTherapy,
    };
