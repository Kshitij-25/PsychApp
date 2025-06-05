import 'package:freezed_annotation/freezed_annotation.dart';

part 'psychologist_model.freezed.dart';
part 'psychologist_model.g.dart';

@freezed
class PsychologistModel with _$PsychologistModel {
  factory PsychologistModel({
    final String? fullName,
    final String? email,
    final String? specialization,
    final double? ratings,
    final int? reviews,
    final String? phoneNumber,
    final String? qualification,
    final String? about,
    final List<String>? publications,
    final List<String>? publicationsLinks,
    final String? avatarData,
    final String? avatarPath,
    final String? avatarUrl,
    final Map<String, String>? availability,
    final List<String>? expertise,
    final List<String>? relationships,
    final List<String>? workStudy,
    final List<String>? happeningsInLife,
    final String? therapistGender,
    final String? sessionTime,
    final String? role,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? dateOfBirth,
    final String? uid,
  }) = _PsychologistModel;

  factory PsychologistModel.fromJson(Map<String, dynamic> json) => _$PsychologistModelFromJson(json);
}
