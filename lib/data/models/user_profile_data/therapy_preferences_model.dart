import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/adapters.dart';

part 'therapy_preferences_model.freezed.dart';
part 'therapy_preferences_model.g.dart';

@freezed
@HiveType(typeId: 2)
class TherapyPreferencesModel with _$TherapyPreferencesModel {
  factory TherapyPreferencesModel({
    @HiveField(0) final String? preferredLanguage,
    @HiveField(1) final String? therapyMode,
    @HiveField(2) final String? professionalType,
    @HiveField(3) final String? preferredProfessionalGender,
  }) = _TherapyPreferencesModel;

  factory TherapyPreferencesModel.fromJson(Map<String, dynamic> json) => _$TherapyPreferencesModelFromJson(json);
}
