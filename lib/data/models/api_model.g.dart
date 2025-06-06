// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiModelImpl _$$ApiModelImplFromJson(Map<String, dynamic> json) =>
    _$ApiModelImpl(
      message: json['message'] as String?,
      statusCode: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiModelImplToJson(_$ApiModelImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.statusCode,
    };
