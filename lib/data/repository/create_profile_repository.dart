import '../models/api_model.dart';
import '../models/professional_profile_data/availability_model.dart';
import '../models/professional_profile_data/credentials_model.dart';
import '../models/professional_profile_data/education_history_model.dart';
import '../models/professional_profile_data/experience_model.dart';
import '../models/professional_profile_data/payment_info_model.dart';
import '../remote_data_source/create_profile_remote_source.dart';

class CreateProfileRepository {
  final CreateProfileRemoteSource _createProfileRemoteSource;

  CreateProfileRepository(this._createProfileRemoteSource);

  Future<ApiModel?> createUserProfile({
    String? fullName,
    String? email,
    String? profilePicUrl,
    DateTime? dateOfBirth,
    String? genderIdentity,
    String? preferredPronouns,
    String? phoneNumber,
    String? location,
    String? preferredLanguage,
    String? therapyMode,
    String? professionalType,
    String? preferredProfessionalGender,
    String? emergencyName,
    String? emergencyRelationship,
    String? emergencyPhone,
  }) async {
    try {
      final response = await _createProfileRemoteSource.createUserProfile(
        dateOfBirth: dateOfBirth,
        email: email,
        emergencyName: emergencyName,
        emergencyPhone: emergencyPhone,
        emergencyRelationship: emergencyRelationship,
        fullName: fullName,
        genderIdentity: genderIdentity,
        location: location,
        phoneNumber: phoneNumber,
        preferredLanguage: preferredLanguage,
        preferredProfessionalGender: preferredProfessionalGender,
        preferredPronouns: preferredPronouns,
        professionalType: professionalType,
        profilePicUrl: profilePicUrl,
        therapyMode: therapyMode,
      );
      return response;
    } catch (e) {
      print('Repository createUserProfile Error: $e');
      rethrow;
    }
  }

  Future<ApiModel?> createProfessionalProfile({
    String? fullName,
    String? dateOfBirth,
    String? genderIdentity,
    String? preferredPronouns,
    String? contactNumber,
    String? email,
    String? address,
    CredentialsModel? credentials,
    List<EducationHistoryModel>? educationHistory,
    ExperienceModel? experience,
    List<String>? therapeuticModalities,
    String? therapyDescription,
    AvailabilityModel? availability,
    PaymentInfoModel? paymentInfo,
    bool? backgroundCheckConsent,
    bool? termsAccepted,
  }) async {
    try {
      final response = await _createProfileRemoteSource.createProfessionalProfile(
        dateOfBirth: dateOfBirth,
        email: email,
        fullName: fullName,
        genderIdentity: genderIdentity,
        preferredPronouns: preferredPronouns,
        address: address,
        availability: availability,
        backgroundCheckConsent: backgroundCheckConsent,
        contactNumber: contactNumber,
        educationHistory: educationHistory,
        credentials: credentials,
        experience: experience,
        paymentInfo: paymentInfo,
        termsAccepted: termsAccepted,
        therapeuticModalities: therapeuticModalities,
        therapyDescription: therapyDescription,
      );
      return response;
    } catch (e) {
      print('Repository createUserProfile Error: $e');
      rethrow;
    }
  }
}
