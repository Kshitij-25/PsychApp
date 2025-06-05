import 'package:freezed_annotation/freezed_annotation.dart';

import 'professional_profile_data/professional_profile_model.dart';
import 'user_profile_data/user_profile_model.dart';

part 'login_model.freezed.dart';
// part 'login_model.g.dart';

@freezed
class LoginModel with _$LoginModel {
  factory LoginModel({
    final String? role,
    final String? email,
    final int? userId,
    final String? accessToken,
    final String? refreshToken,
    @JsonKey(includeFromJson: true) dynamic profile, // ✅ Dynamic type
  }) = _LoginModel;

  // ✅ Custom Deserialization Based on Role
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final role = json['role'] as String?;
    final profileData = json['profile'];

    dynamic profile;

    if (role == 'USER' && profileData != null) {
      profile = UserProfileModel.fromJson(profileData);
    } else if (role == 'PROFESSIONAL' && profileData != null) {
      profile = ProfessionalProfileModel.fromJson(profileData);
    }

    return LoginModel(
      role: role,
      email: json['email'] as String?,
      userId: json['userId'] as int?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      profile: profile,
    );
  }
}
