// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvailabilityModelImpl _$$AvailabilityModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailabilityModelImpl(
      dailyAvailability: json['dailyAvailability'] == null
          ? null
          : DailyAvailability.fromJson(
              json['dailyAvailability'] as Map<String, dynamic>),
      timeZone: json['timeZone'] as String?,
      acceptingNewClients: json['acceptingNewClients'] as bool?,
    );

Map<String, dynamic> _$$AvailabilityModelImplToJson(
        _$AvailabilityModelImpl instance) =>
    <String, dynamic>{
      'dailyAvailability': instance.dailyAvailability,
      'timeZone': instance.timeZone,
      'acceptingNewClients': instance.acceptingNewClients,
    };
