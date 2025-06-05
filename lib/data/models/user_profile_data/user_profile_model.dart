import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/adapters.dart';

import 'emergeny_contact_model.dart';
import 'therapy_preferences_model.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
@HiveType(typeId: 0)
class UserProfileModel extends HiveObject with _$UserProfileModel {
  factory UserProfileModel({
    @HiveField(0) final int? id,
    @HiveField(1) final String? fullName,
    @HiveField(2) final String? profilePicUrl,
    @HiveField(3) final DateTime? dateOfBirth,
    @HiveField(4) final String? genderIdentity,
    @HiveField(5) final String? preferredPronouns,
    @HiveField(6) final String? email,
    @HiveField(7) final String? phoneNumber,
    @HiveField(8) final String? location,
    @HiveField(9) final EmergenyContactModel? emergencyContact,
    @HiveField(10) final TherapyPreferencesModel? therapyPreferences,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
}
