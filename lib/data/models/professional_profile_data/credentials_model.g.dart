// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CredentialsModelImpl _$$CredentialsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CredentialsModelImpl(
      professionalTitle: json['professionalTitle'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      issuingAuthority: json['issuingAuthority'] as String?,
      licenseExpiry: json['licenseExpiry'] as String?,
      multipleLicenses: json['multipleLicenses'] as bool?,
      boardCertified: json['boardCertified'] as bool?,
    );

Map<String, dynamic> _$$CredentialsModelImplToJson(
        _$CredentialsModelImpl instance) =>
    <String, dynamic>{
      'professionalTitle': instance.professionalTitle,
      'licenseNumber': instance.licenseNumber,
      'issuingAuthority': instance.issuingAuthority,
      'licenseExpiry': instance.licenseExpiry,
      'multipleLicenses': instance.multipleLicenses,
      'boardCertified': instance.boardCertified,
    };
