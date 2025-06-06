// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'therapy_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TherapyPreferencesModelAdapter
    extends TypeAdapter<TherapyPreferencesModel> {
  @override
  final int typeId = 2;

  @override
  TherapyPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TherapyPreferencesModel(
      preferredLanguage: fields[0] as String?,
      therapyMode: fields[1] as String?,
      professionalType: fields[2] as String?,
      preferredProfessionalGender: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TherapyPreferencesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.preferredLanguage)
      ..writeByte(1)
      ..write(obj.therapyMode)
      ..writeByte(2)
      ..write(obj.professionalType)
      ..writeByte(3)
      ..write(obj.preferredProfessionalGender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TherapyPreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TherapyPreferencesModelImpl _$$TherapyPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TherapyPreferencesModelImpl(
      preferredLanguage: json['preferredLanguage'] as String?,
      therapyMode: json['therapyMode'] as String?,
      professionalType: json['professionalType'] as String?,
      preferredProfessionalGender:
          json['preferredProfessionalGender'] as String?,
    );

Map<String, dynamic> _$$TherapyPreferencesModelImplToJson(
        _$TherapyPreferencesModelImpl instance) =>
    <String, dynamic>{
      'preferredLanguage': instance.preferredLanguage,
      'therapyMode': instance.therapyMode,
      'professionalType': instance.professionalType,
      'preferredProfessionalGender': instance.preferredProfessionalGender,
    };
