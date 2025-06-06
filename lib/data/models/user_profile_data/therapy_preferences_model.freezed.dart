// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'therapy_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TherapyPreferencesModel _$TherapyPreferencesModelFromJson(
    Map<String, dynamic> json) {
  return _TherapyPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$TherapyPreferencesModel {
  @HiveField(0)
  String? get preferredLanguage => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get therapyMode => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get professionalType => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get preferredProfessionalGender => throw _privateConstructorUsedError;

  /// Serializes this TherapyPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TherapyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TherapyPreferencesModelCopyWith<TherapyPreferencesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TherapyPreferencesModelCopyWith<$Res> {
  factory $TherapyPreferencesModelCopyWith(TherapyPreferencesModel value,
          $Res Function(TherapyPreferencesModel) then) =
      _$TherapyPreferencesModelCopyWithImpl<$Res, TherapyPreferencesModel>;
  @useResult
  $Res call(
      {@HiveField(0) String? preferredLanguage,
      @HiveField(1) String? therapyMode,
      @HiveField(2) String? professionalType,
      @HiveField(3) String? preferredProfessionalGender});
}

/// @nodoc
class _$TherapyPreferencesModelCopyWithImpl<$Res,
        $Val extends TherapyPreferencesModel>
    implements $TherapyPreferencesModelCopyWith<$Res> {
  _$TherapyPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TherapyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredLanguage = freezed,
    Object? therapyMode = freezed,
    Object? professionalType = freezed,
    Object? preferredProfessionalGender = freezed,
  }) {
    return _then(_value.copyWith(
      preferredLanguage: freezed == preferredLanguage
          ? _value.preferredLanguage
          : preferredLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      therapyMode: freezed == therapyMode
          ? _value.therapyMode
          : therapyMode // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalType: freezed == professionalType
          ? _value.professionalType
          : professionalType // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredProfessionalGender: freezed == preferredProfessionalGender
          ? _value.preferredProfessionalGender
          : preferredProfessionalGender // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TherapyPreferencesModelImplCopyWith<$Res>
    implements $TherapyPreferencesModelCopyWith<$Res> {
  factory _$$TherapyPreferencesModelImplCopyWith(
          _$TherapyPreferencesModelImpl value,
          $Res Function(_$TherapyPreferencesModelImpl) then) =
      __$$TherapyPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? preferredLanguage,
      @HiveField(1) String? therapyMode,
      @HiveField(2) String? professionalType,
      @HiveField(3) String? preferredProfessionalGender});
}

/// @nodoc
class __$$TherapyPreferencesModelImplCopyWithImpl<$Res>
    extends _$TherapyPreferencesModelCopyWithImpl<$Res,
        _$TherapyPreferencesModelImpl>
    implements _$$TherapyPreferencesModelImplCopyWith<$Res> {
  __$$TherapyPreferencesModelImplCopyWithImpl(
      _$TherapyPreferencesModelImpl _value,
      $Res Function(_$TherapyPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TherapyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredLanguage = freezed,
    Object? therapyMode = freezed,
    Object? professionalType = freezed,
    Object? preferredProfessionalGender = freezed,
  }) {
    return _then(_$TherapyPreferencesModelImpl(
      preferredLanguage: freezed == preferredLanguage
          ? _value.preferredLanguage
          : preferredLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      therapyMode: freezed == therapyMode
          ? _value.therapyMode
          : therapyMode // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalType: freezed == professionalType
          ? _value.professionalType
          : professionalType // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredProfessionalGender: freezed == preferredProfessionalGender
          ? _value.preferredProfessionalGender
          : preferredProfessionalGender // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TherapyPreferencesModelImpl implements _TherapyPreferencesModel {
  _$TherapyPreferencesModelImpl(
      {@HiveField(0) this.preferredLanguage,
      @HiveField(1) this.therapyMode,
      @HiveField(2) this.professionalType,
      @HiveField(3) this.preferredProfessionalGender});

  factory _$TherapyPreferencesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TherapyPreferencesModelImplFromJson(json);

  @override
  @HiveField(0)
  final String? preferredLanguage;
  @override
  @HiveField(1)
  final String? therapyMode;
  @override
  @HiveField(2)
  final String? professionalType;
  @override
  @HiveField(3)
  final String? preferredProfessionalGender;

  @override
  String toString() {
    return 'TherapyPreferencesModel(preferredLanguage: $preferredLanguage, therapyMode: $therapyMode, professionalType: $professionalType, preferredProfessionalGender: $preferredProfessionalGender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TherapyPreferencesModelImpl &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                other.preferredLanguage == preferredLanguage) &&
            (identical(other.therapyMode, therapyMode) ||
                other.therapyMode == therapyMode) &&
            (identical(other.professionalType, professionalType) ||
                other.professionalType == professionalType) &&
            (identical(other.preferredProfessionalGender,
                    preferredProfessionalGender) ||
                other.preferredProfessionalGender ==
                    preferredProfessionalGender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, preferredLanguage, therapyMode,
      professionalType, preferredProfessionalGender);

  /// Create a copy of TherapyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TherapyPreferencesModelImplCopyWith<_$TherapyPreferencesModelImpl>
      get copyWith => __$$TherapyPreferencesModelImplCopyWithImpl<
          _$TherapyPreferencesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TherapyPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _TherapyPreferencesModel implements TherapyPreferencesModel {
  factory _TherapyPreferencesModel(
          {@HiveField(0) final String? preferredLanguage,
          @HiveField(1) final String? therapyMode,
          @HiveField(2) final String? professionalType,
          @HiveField(3) final String? preferredProfessionalGender}) =
      _$TherapyPreferencesModelImpl;

  factory _TherapyPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$TherapyPreferencesModelImpl.fromJson;

  @override
  @HiveField(0)
  String? get preferredLanguage;
  @override
  @HiveField(1)
  String? get therapyMode;
  @override
  @HiveField(2)
  String? get professionalType;
  @override
  @HiveField(3)
  String? get preferredProfessionalGender;

  /// Create a copy of TherapyPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TherapyPreferencesModelImplCopyWith<_$TherapyPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
