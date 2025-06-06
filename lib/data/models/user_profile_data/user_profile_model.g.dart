// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 0;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      id: fields[0] as int?,
      fullName: fields[1] as String?,
      profilePicUrl: fields[2] as String?,
      dateOfBirth: fields[3] as DateTime?,
      genderIdentity: fields[4] as String?,
      preferredPronouns: fields[5] as String?,
      email: fields[6] as String?,
      phoneNumber: fields[7] as String?,
      location: fields[8] as String?,
      emergencyContact: fields[9] as EmergenyContactModel?,
      therapyPreferences: fields[10] as TherapyPreferencesModel?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.profilePicUrl)
      ..writeByte(3)
      ..write(obj.dateOfBirth)
      ..writeByte(4)
      ..write(obj.genderIdentity)
      ..writeByte(5)
      ..write(obj.preferredPronouns)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phoneNumber)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.emergencyContact)
      ..writeByte(10)
      ..write(obj.therapyPreferences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      id: (json['id'] as num?)?.toInt(),
      fullName: json['fullName'] as String?,
      profilePicUrl: json['profilePicUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      genderIdentity: json['genderIdentity'] as String?,
      preferredPronouns: json['preferredPronouns'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      emergencyContact: json['emergencyContact'] == null
          ? null
          : EmergenyContactModel.fromJson(
              json['emergencyContact'] as Map<String, dynamic>),
      therapyPreferences: json['therapyPreferences'] == null
          ? null
          : TherapyPreferencesModel.fromJson(
              json['therapyPreferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'profilePicUrl': instance.profilePicUrl,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'genderIdentity': instance.genderIdentity,
      'preferredPronouns': instance.preferredPronouns,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'location': instance.location,
      'emergencyContact': instance.emergencyContact,
      'therapyPreferences': instance.therapyPreferences,
    };
