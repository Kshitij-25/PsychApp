// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfessionalProfileModelImpl _$$ProfessionalProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfessionalProfileModelImpl(
      id: (json['id'] as num?)?.toInt(),
      fullName: json['fullName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      genderIdentity: json['genderIdentity'] as String?,
      preferredPronouns: json['preferredPronouns'] as String?,
      contactNumber: json['contactNumber'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      credentials: json['credentials'] == null
          ? null
          : CredentialsModel.fromJson(
              json['credentials'] as Map<String, dynamic>),
      educationHistory: (json['educationHistory'] as List<dynamic>?)
          ?.map(
              (e) => EducationHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      experience: json['experience'] == null
          ? null
          : ExperienceModel.fromJson(
              json['experience'] as Map<String, dynamic>),
      therapeuticModalities: (json['therapeuticModalities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      therapyDescription: json['therapyDescription'] as String?,
      availability: json['availability'] == null
          ? null
          : AvailabilityModel.fromJson(
              json['availability'] as Map<String, dynamic>),
      paymentInfo: json['paymentInfo'] == null
          ? null
          : PaymentInfoModel.fromJson(
              json['paymentInfo'] as Map<String, dynamic>),
      backgroundCheckConsent: json['backgroundCheckConsent'] as bool?,
      termsAccepted: json['termsAccepted'] as bool?,
      documents: json['documents'] == null
          ? null
          : Documents.fromJson(json['documents'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProfessionalProfileModelImplToJson(
        _$ProfessionalProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'profileImageUrl': instance.profileImageUrl,
      'dateOfBirth': instance.dateOfBirth,
      'genderIdentity': instance.genderIdentity,
      'preferredPronouns': instance.preferredPronouns,
      'contactNumber': instance.contactNumber,
      'email': instance.email,
      'address': instance.address,
      'credentials': instance.credentials,
      'educationHistory': instance.educationHistory,
      'experience': instance.experience,
      'therapeuticModalities': instance.therapeuticModalities,
      'therapyDescription': instance.therapyDescription,
      'availability': instance.availability,
      'paymentInfo': instance.paymentInfo,
      'backgroundCheckConsent': instance.backgroundCheckConsent,
      'termsAccepted': instance.termsAccepted,
      'documents': instance.documents,
    };
