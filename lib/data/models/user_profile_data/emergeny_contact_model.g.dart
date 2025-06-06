// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergeny_contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmergenyContactModelAdapter extends TypeAdapter<EmergenyContactModel> {
  @override
  final int typeId = 1;

  @override
  EmergenyContactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmergenyContactModel(
      emergencyName: fields[0] as String?,
      emergencyRelationship: fields[1] as String?,
      emergencyPhone: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EmergenyContactModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.emergencyName)
      ..writeByte(1)
      ..write(obj.emergencyRelationship)
      ..writeByte(2)
      ..write(obj.emergencyPhone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergenyContactModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmergenyContactModelImpl _$$EmergenyContactModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EmergenyContactModelImpl(
      emergencyName: json['emergencyName'] as String?,
      emergencyRelationship: json['emergencyRelationship'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
    );

Map<String, dynamic> _$$EmergenyContactModelImplToJson(
        _$EmergenyContactModelImpl instance) =>
    <String, dynamic>{
      'emergencyName': instance.emergencyName,
      'emergencyRelationship': instance.emergencyRelationship,
      'emergencyPhone': instance.emergencyPhone,
    };
