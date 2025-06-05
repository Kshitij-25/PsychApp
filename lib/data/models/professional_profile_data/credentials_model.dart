import 'package:freezed_annotation/freezed_annotation.dart';

part 'credentials_model.freezed.dart';
part 'credentials_model.g.dart';

@freezed
class CredentialsModel with _$CredentialsModel {
  factory CredentialsModel({
    final String? professionalTitle,
    final String? licenseNumber,
    final String? issuingAuthority,
    final String? licenseExpiry,
    final bool? multipleLicenses,
    final bool? boardCertified,
  }) = _CredentialsModel;

  factory CredentialsModel.fromJson(Map<String, dynamic> json) => _$CredentialsModelFromJson(json);
}
