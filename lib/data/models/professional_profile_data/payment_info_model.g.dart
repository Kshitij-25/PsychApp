// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentInfoModelImpl _$$PaymentInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentInfoModelImpl(
      acceptsInsurance: json['acceptsInsurance'] as bool?,
      acceptedInsurances: (json['acceptedInsurances'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sessionFees: json['sessionFees'] as String?,
      slidingScaleAvailable: json['slidingScaleAvailable'] as bool?,
    );

Map<String, dynamic> _$$PaymentInfoModelImplToJson(
        _$PaymentInfoModelImpl instance) =>
    <String, dynamic>{
      'acceptsInsurance': instance.acceptsInsurance,
      'acceptedInsurances': instance.acceptedInsurances,
      'sessionFees': instance.sessionFees,
      'slidingScaleAvailable': instance.slidingScaleAvailable,
    };
