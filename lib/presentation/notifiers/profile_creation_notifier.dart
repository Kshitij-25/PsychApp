import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/professional_profile_data/professional_profile_model.dart';
import '../../data/models/user_profile_data/user_profile_model.dart';
import '../../data/repository/create_profile_repository.dart';
import '../providers/profile_creation_providers.dart';

class UserProfileFormNotifier extends StateNotifier<UserProfileModel> {
  final CreateProfileRepository _repository;

  UserProfileFormNotifier(this._repository) : super(UserProfileModel());

  void updateField(UserProfileModel updatedProfile) {
    state = updatedProfile;
  }

  Future<bool> submitProfile() async {
    try {
      final response = await _repository.createUserProfile(
        fullName: state.fullName,
        email: state.email,
        profilePicUrl: state.profilePicUrl,
        dateOfBirth: state.dateOfBirth,
        genderIdentity: state.genderIdentity,
        preferredPronouns: state.preferredPronouns,
        phoneNumber: state.phoneNumber,
        location: state.location,
        preferredLanguage: state.therapyPreferences?.preferredLanguage,
        therapyMode: state.therapyPreferences?.therapyMode,
        professionalType: state.therapyPreferences?.professionalType,
        preferredProfessionalGender: state.therapyPreferences?.preferredProfessionalGender,
        emergencyName: state.emergencyContact?.emergencyName,
        emergencyRelationship: state.emergencyContact?.emergencyRelationship,
        emergencyPhone: state.emergencyContact?.emergencyPhone,
      );

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error submitting profile: $e');
      return false;
    }
  }
}

// ✅ Provider for User Profile
final userProfileFormProvider = StateNotifierProvider<UserProfileFormNotifier, UserProfileModel>(
  (ref) => UserProfileFormNotifier(ref.watch(createProfileRepositoryProvider)),
);

class ProfessionalProfileFormNotifier extends StateNotifier<ProfessionalProfileModel> {
  final CreateProfileRepository _repository;

  ProfessionalProfileFormNotifier(this._repository) : super(ProfessionalProfileModel());

  void updateField(ProfessionalProfileModel updatedProfile) {
    state = updatedProfile;
  }

  Future<bool> submitProfile() async {
    try {
      final response = await _repository.createProfessionalProfile(
        fullName: state.fullName,
        dateOfBirth: state.dateOfBirth,
        genderIdentity: state.genderIdentity,
        preferredPronouns: state.preferredPronouns,
        contactNumber: state.contactNumber,
        email: state.email,
        address: state.address,
        credentials: state.credentials,
        educationHistory: state.educationHistory,
        experience: state.experience,
        therapeuticModalities: state.therapeuticModalities,
        therapyDescription: state.therapyDescription,
        availability: state.availability,
        paymentInfo: state.paymentInfo,
        backgroundCheckConsent: state.backgroundCheckConsent,
        termsAccepted: state.termsAccepted,
      );

      return response != null;
    } catch (e) {
      print('Error submitting professional profile: $e');
      return false;
    }
  }
}

// ✅ Provider for Professional Profile
final professionalProfileFormProvider = StateNotifierProvider<ProfessionalProfileFormNotifier, ProfessionalProfileModel>(
  (ref) => ProfessionalProfileFormNotifier(ref.watch(createProfileRepositoryProvider)),
);
