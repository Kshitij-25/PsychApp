import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_history_model.freezed.dart';
part 'education_history_model.g.dart';

@freezed
class EducationHistoryModel with _$EducationHistoryModel {
  factory EducationHistoryModel({
    final String? degree,
    final String? institution,
    final int? graduationYear,
    final String? specializations,
    final List<String>? specializationsList,
  }) = _EducationHistoryModel;

  factory EducationHistoryModel.fromJson(Map<String, dynamic> json) => _$EducationHistoryModelFromJson(json);
}
