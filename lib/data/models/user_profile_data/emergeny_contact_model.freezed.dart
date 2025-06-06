// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergeny_contact_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmergenyContactModel _$EmergenyContactModelFromJson(Map<String, dynamic> json) {
  return _EmergenyContactModel.fromJson(json);
}

/// @nodoc
mixin _$EmergenyContactModel {
  @HiveField(0)
  String? get emergencyName => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get emergencyRelationship => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get emergencyPhone => throw _privateConstructorUsedError;

  /// Serializes this EmergenyContactModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmergenyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmergenyContactModelCopyWith<EmergenyContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergenyContactModelCopyWith<$Res> {
  factory $EmergenyContactModelCopyWith(EmergenyContactModel value,
          $Res Function(EmergenyContactModel) then) =
      _$EmergenyContactModelCopyWithImpl<$Res, EmergenyContactModel>;
  @useResult
  $Res call(
      {@HiveField(0) String? emergencyName,
      @HiveField(1) String? emergencyRelationship,
      @HiveField(2) String? emergencyPhone});
}

/// @nodoc
class _$EmergenyContactModelCopyWithImpl<$Res,
        $Val extends EmergenyContactModel>
    implements $EmergenyContactModelCopyWith<$Res> {
  _$EmergenyContactModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmergenyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emergencyName = freezed,
    Object? emergencyRelationship = freezed,
    Object? emergencyPhone = freezed,
  }) {
    return _then(_value.copyWith(
      emergencyName: freezed == emergencyName
          ? _value.emergencyName
          : emergencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyRelationship: freezed == emergencyRelationship
          ? _value.emergencyRelationship
          : emergencyRelationship // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyPhone: freezed == emergencyPhone
          ? _value.emergencyPhone
          : emergencyPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmergenyContactModelImplCopyWith<$Res>
    implements $EmergenyContactModelCopyWith<$Res> {
  factory _$$EmergenyContactModelImplCopyWith(_$EmergenyContactModelImpl value,
          $Res Function(_$EmergenyContactModelImpl) then) =
      __$$EmergenyContactModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? emergencyName,
      @HiveField(1) String? emergencyRelationship,
      @HiveField(2) String? emergencyPhone});
}

/// @nodoc
class __$$EmergenyContactModelImplCopyWithImpl<$Res>
    extends _$EmergenyContactModelCopyWithImpl<$Res, _$EmergenyContactModelImpl>
    implements _$$EmergenyContactModelImplCopyWith<$Res> {
  __$$EmergenyContactModelImplCopyWithImpl(_$EmergenyContactModelImpl _value,
      $Res Function(_$EmergenyContactModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmergenyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emergencyName = freezed,
    Object? emergencyRelationship = freezed,
    Object? emergencyPhone = freezed,
  }) {
    return _then(_$EmergenyContactModelImpl(
      emergencyName: freezed == emergencyName
          ? _value.emergencyName
          : emergencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyRelationship: freezed == emergencyRelationship
          ? _value.emergencyRelationship
          : emergencyRelationship // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyPhone: freezed == emergencyPhone
          ? _value.emergencyPhone
          : emergencyPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmergenyContactModelImpl implements _EmergenyContactModel {
  _$EmergenyContactModelImpl(
      {@HiveField(0) this.emergencyName,
      @HiveField(1) this.emergencyRelationship,
      @HiveField(2) this.emergencyPhone});

  factory _$EmergenyContactModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmergenyContactModelImplFromJson(json);

  @override
  @HiveField(0)
  final String? emergencyName;
  @override
  @HiveField(1)
  final String? emergencyRelationship;
  @override
  @HiveField(2)
  final String? emergencyPhone;

  @override
  String toString() {
    return 'EmergenyContactModel(emergencyName: $emergencyName, emergencyRelationship: $emergencyRelationship, emergencyPhone: $emergencyPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergenyContactModelImpl &&
            (identical(other.emergencyName, emergencyName) ||
                other.emergencyName == emergencyName) &&
            (identical(other.emergencyRelationship, emergencyRelationship) ||
                other.emergencyRelationship == emergencyRelationship) &&
            (identical(other.emergencyPhone, emergencyPhone) ||
                other.emergencyPhone == emergencyPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, emergencyName, emergencyRelationship, emergencyPhone);

  /// Create a copy of EmergenyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergenyContactModelImplCopyWith<_$EmergenyContactModelImpl>
      get copyWith =>
          __$$EmergenyContactModelImplCopyWithImpl<_$EmergenyContactModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmergenyContactModelImplToJson(
      this,
    );
  }
}

abstract class _EmergenyContactModel implements EmergenyContactModel {
  factory _EmergenyContactModel(
      {@HiveField(0) final String? emergencyName,
      @HiveField(1) final String? emergencyRelationship,
      @HiveField(2) final String? emergencyPhone}) = _$EmergenyContactModelImpl;

  factory _EmergenyContactModel.fromJson(Map<String, dynamic> json) =
      _$EmergenyContactModelImpl.fromJson;

  @override
  @HiveField(0)
  String? get emergencyName;
  @override
  @HiveField(1)
  String? get emergencyRelationship;
  @override
  @HiveField(2)
  String? get emergencyPhone;

  /// Create a copy of EmergenyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmergenyContactModelImplCopyWith<_$EmergenyContactModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
