import 'package:freezed_annotation/freezed_annotation.dart';

part 'experience_model.freezed.dart';
part 'experience_model.g.dart';

@freezed
class ExperienceModel with _$ExperienceModel {
  factory ExperienceModel({
    final int? yearsExperience,
    final List<String>? expertiseAreas,
    final List<String>? preferredAgeGroups,
    final List<String>? languagesSpoken,
    final bool? offersCouplesTherapy,
    final bool? offersGroupTherapy,
  }) = _ExperienceModel;

  factory ExperienceModel.fromJson(Map<String, dynamic> json) => _$ExperienceModelFromJson(json);
}
