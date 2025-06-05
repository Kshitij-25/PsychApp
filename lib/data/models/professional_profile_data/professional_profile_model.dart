import 'package:freezed_annotation/freezed_annotation.dart';

import 'availability_model.dart';
import 'credentials_model.dart';
import 'documents_model.dart';
import 'education_history_model.dart';
import 'experience_model.dart';
import 'payment_info_model.dart';

part 'professional_profile_model.freezed.dart';
part 'professional_profile_model.g.dart';

@freezed
class ProfessionalProfileModel with _$ProfessionalProfileModel {
  factory ProfessionalProfileModel({
    final int? id,
    final String? fullName,
    final String? profileImageUrl,
    final String? dateOfBirth,
    final String? genderIdentity,
    final String? preferredPronouns,
    final String? contactNumber,
    final String? email,
    final String? address,
    final CredentialsModel? credentials,
    final List<EducationHistoryModel>? educationHistory,
    final ExperienceModel? experience,
    final List<String>? therapeuticModalities,
    final String? therapyDescription,
    final AvailabilityModel? availability,
    final PaymentInfoModel? paymentInfo,
    final bool? backgroundCheckConsent,
    final bool? termsAccepted,
    final Documents? documents,
  }) = _ProfessionalProfileModel;

  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) => _$ProfessionalProfileModelFromJson(json);
}
