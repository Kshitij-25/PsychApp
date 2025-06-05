import 'package:intl/intl.dart';

import '../../shared/constants/api_constants.dart';
import '../core/dio_client.dart';
import '../models/api_model.dart';
import '../models/professional_profile_data/availability_model.dart';
import '../models/professional_profile_data/credentials_model.dart';
import '../models/professional_profile_data/education_history_model.dart';
import '../models/professional_profile_data/experience_model.dart';
import '../models/professional_profile_data/payment_info_model.dart';

class CreateProfileRemoteSource {
  static final CreateProfileRemoteSource _instance = CreateProfileRemoteSource._internal();

  CreateProfileRemoteSource._internal();

  factory CreateProfileRemoteSource() => _instance;

  final DioClient _dioClient = DioClient();

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
      final response = await _dioClient.post(
        ApiConstants.createUserProfile,
        data: {
          "fullName": fullName,
          "email": email,
          "profilePicUrl": profilePicUrl,
          "dateOfBirth": DateFormat('yyyy-MM-dd').format(dateOfBirth!),
          "genderIdentity": genderIdentity,
          "preferredPronouns": preferredPronouns,
          "phoneNumber": phoneNumber,
          "location": location,
          "therapyPreferences": {
            "preferredLanguage": preferredLanguage,
            "therapyMode": therapyMode,
            "professionalType": professionalType,
            "preferredProfessionalGender": preferredProfessionalGender,
          },
          "emergencyContact": {
            "emergencyName": emergencyName,
            "emergencyRelationship": emergencyRelationship,
            "emergencyPhone": emergencyPhone,
          }
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        return ApiModel.fromJson(response.data);
      } else {
        throw Exception('Couldn\'t create User Profile. Please try again.');
      }
    } catch (e) {
      print('createUserProfile Error: $e');
      throw e;
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
    // String? professionalTitle,
    // String? licenseNumber,
    // String? issuingAuthority,
    // String? licenseExpiry,
    // bool? multipleLicenses,
    // bool? boardCertified,
    CredentialsModel? credentials,
    List<EducationHistoryModel>? educationHistory,
    ExperienceModel? experience,
    // int? yearsExperience,
    // List<String>? expertiseAreas,
    // List<String>? preferredAgeGroups,
    // List<String>? languagesSpoken,
    // bool? offersCouplesTherapy,
    // bool? offersGroupTherapy,
    List<String>? therapeuticModalities,
    String? therapyDescription,
    AvailabilityModel? availability,
    // String? timeZone,
    // bool? acceptingNewClients,
    // bool? acceptsInsurance,
    // List<String>? acceptedInsurances,
    // String? sessionFees,
    // bool? slidingScaleAvailable,
    PaymentInfoModel? paymentInfo,
    bool? backgroundCheckConsent,
    bool? termsAccepted,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.createProfessionalProfile,
        data: {
          "fullName": fullName,
          "dateOfBirth": dateOfBirth,
          "genderIdentity": genderIdentity,
          "preferredPronouns": preferredPronouns,
          "contactNumber": contactNumber,
          "email": email,
          "address": address,
          "credentials": credentials,
          // "professionalTitle": professionalTitle,
          // "licenseNumber": licenseNumber,
          // "issuingAuthority": issuingAuthority,
          // "licenseExpiry": licenseExpiry,
          // "multipleLicenses": multipleLicenses,
          // "boardCertified": boardCertified,
          "educationHistory": educationHistory,
          "experience": experience,
          // "yearsExperience": yearsExperience,
          // "expertiseAreas": expertiseAreas,
          // "preferredAgeGroups": preferredAgeGroups,
          // "languagesSpoken": languagesSpoken,
          // "offersCouplesTherapy": offersCouplesTherapy,
          // "offersGroupTherapy": offersGroupTherapy,
          "therapeuticModalities": therapeuticModalities,
          "therapyDescription": therapyDescription,
          "availability": availability,
          // "timeZone": timeZone,
          // "acceptingNewClients": acceptingNewClients,
          "paymentInfo": paymentInfo,
          // "acceptsInsurance": acceptsInsurance,
          // "acceptedInsurances": acceptedInsurances,
          // "sessionFees": sessionFees,
          // "slidingScaleAvailable": slidingScaleAvailable,
          "backgroundCheckConsent": backgroundCheckConsent,
          "termsAccepted": termsAccepted,
        },
      );

      if (response.statusCode == 200) {
        print("Profile Created Successfully: ${response.data}");
        return ApiModel.fromJson(response.data);
      } else {
        throw Exception('Couldn\'t create Professional Profile. Please try again.');
      }
    } catch (e) {
      print('createProfessionalProfile Error: $e');
      throw e;
    }
  }
}
