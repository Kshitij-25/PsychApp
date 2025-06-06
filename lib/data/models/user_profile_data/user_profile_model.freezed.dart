// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  @HiveField(0)
  int? get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get fullName => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get profilePicUrl => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get genderIdentity => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get preferredPronouns => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get email => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get phoneNumber => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get location => throw _privateConstructorUsedError;
  @HiveField(9)
  EmergenyContactModel? get emergencyContact =>
      throw _privateConstructorUsedError;
  @HiveField(10)
  TherapyPreferencesModel? get therapyPreferences =>
      throw _privateConstructorUsedError;

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
          UserProfileModel value, $Res Function(UserProfileModel) then) =
      _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call(
      {@HiveField(0) int? id,
      @HiveField(1) String? fullName,
      @HiveField(2) String? profilePicUrl,
      @HiveField(3) DateTime? dateOfBirth,
      @HiveField(4) String? genderIdentity,
      @HiveField(5) String? preferredPronouns,
      @HiveField(6) String? email,
      @HiveField(7) String? phoneNumber,
      @HiveField(8) String? location,
      @HiveField(9) EmergenyContactModel? emergencyContact,
      @HiveField(10) TherapyPreferencesModel? therapyPreferences});

  $EmergenyContactModelCopyWith<$Res>? get emergencyContact;
  $TherapyPreferencesModelCopyWith<$Res>? get therapyPreferences;
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = freezed,
    Object? profilePicUrl = freezed,
    Object? dateOfBirth = freezed,
    Object? genderIdentity = freezed,
    Object? preferredPronouns = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? location = freezed,
    Object? emergencyContact = freezed,
    Object? therapyPreferences = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicUrl: freezed == profilePicUrl
          ? _value.profilePicUrl
          : profilePicUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      genderIdentity: freezed == genderIdentity
          ? _value.genderIdentity
          : genderIdentity // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredPronouns: freezed == preferredPronouns
          ? _value.preferredPronouns
          : preferredPronouns // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as EmergenyContactModel?,
      therapyPreferences: freezed == therapyPreferences
          ? _value.therapyPreferences
          : therapyPreferences // ignore: cast_nullable_to_non_nullable
              as TherapyPreferencesModel?,
    ) as $Val);
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmergenyContactModelCopyWith<$Res>? get emergencyContact {
    if (_value.emergencyContact == null) {
      return null;
    }

    return $EmergenyContactModelCopyWith<$Res>(_value.emergencyContact!,
        (value) {
      return _then(_value.copyWith(emergencyContact: value) as $Val);
    });
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TherapyPreferencesModelCopyWith<$Res>? get therapyPreferences {
    if (_value.therapyPreferences == null) {
      return null;
    }

    return $TherapyPreferencesModelCopyWith<$Res>(_value.therapyPreferences!,
        (value) {
      return _then(_value.copyWith(therapyPreferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(_$UserProfileModelImpl value,
          $Res Function(_$UserProfileModelImpl) then) =
      __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int? id,
      @HiveField(1) String? fullName,
      @HiveField(2) String? profilePicUrl,
      @HiveField(3) DateTime? dateOfBirth,
      @HiveField(4) String? genderIdentity,
      @HiveField(5) String? preferredPronouns,
      @HiveField(6) String? email,
      @HiveField(7) String? phoneNumber,
      @HiveField(8) String? location,
      @HiveField(9) EmergenyContactModel? emergencyContact,
      @HiveField(10) TherapyPreferencesModel? therapyPreferences});

  @override
  $EmergenyContactModelCopyWith<$Res>? get emergencyContact;
  @override
  $TherapyPreferencesModelCopyWith<$Res>? get therapyPreferences;
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(_$UserProfileModelImpl _value,
      $Res Function(_$UserProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = freezed,
    Object? profilePicUrl = freezed,
    Object? dateOfBirth = freezed,
    Object? genderIdentity = freezed,
    Object? preferredPronouns = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? location = freezed,
    Object? emergencyContact = freezed,
    Object? therapyPreferences = freezed,
  }) {
    return _then(_$UserProfileModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicUrl: freezed == profilePicUrl
          ? _value.profilePicUrl
          : profilePicUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      genderIdentity: freezed == genderIdentity
          ? _value.genderIdentity
          : genderIdentity // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredPronouns: freezed == preferredPronouns
          ? _value.preferredPronouns
          : preferredPronouns // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as EmergenyContactModel?,
      therapyPreferences: freezed == therapyPreferences
          ? _value.therapyPreferences
          : therapyPreferences // ignore: cast_nullable_to_non_nullable
              as TherapyPreferencesModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl extends HiveObject implements _UserProfileModel {
  _$UserProfileModelImpl(
      {@HiveField(0) this.id,
      @HiveField(1) this.fullName,
      @HiveField(2) this.profilePicUrl,
      @HiveField(3) this.dateOfBirth,
      @HiveField(4) this.genderIdentity,
      @HiveField(5) this.preferredPronouns,
      @HiveField(6) this.email,
      @HiveField(7) this.phoneNumber,
      @HiveField(8) this.location,
      @HiveField(9) this.emergencyContact,
      @HiveField(10) this.therapyPreferences});

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  @HiveField(0)
  final int? id;
  @override
  @HiveField(1)
  final String? fullName;
  @override
  @HiveField(2)
  final String? profilePicUrl;
  @override
  @HiveField(3)
  final DateTime? dateOfBirth;
  @override
  @HiveField(4)
  final String? genderIdentity;
  @override
  @HiveField(5)
  final String? preferredPronouns;
  @override
  @HiveField(6)
  final String? email;
  @override
  @HiveField(7)
  final String? phoneNumber;
  @override
  @HiveField(8)
  final String? location;
  @override
  @HiveField(9)
  final EmergenyContactModel? emergencyContact;
  @override
  @HiveField(10)
  final TherapyPreferencesModel? therapyPreferences;

  @override
  String toString() {
    return 'UserProfileModel(id: $id, fullName: $fullName, profilePicUrl: $profilePicUrl, dateOfBirth: $dateOfBirth, genderIdentity: $genderIdentity, preferredPronouns: $preferredPronouns, email: $email, phoneNumber: $phoneNumber, location: $location, emergencyContact: $emergencyContact, therapyPreferences: $therapyPreferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.profilePicUrl, profilePicUrl) ||
                other.profilePicUrl == profilePicUrl) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.genderIdentity, genderIdentity) ||
                other.genderIdentity == genderIdentity) &&
            (identical(other.preferredPronouns, preferredPronouns) ||
                other.preferredPronouns == preferredPronouns) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.emergencyContact, emergencyContact) ||
                other.emergencyContact == emergencyContact) &&
            (identical(other.therapyPreferences, therapyPreferences) ||
                other.therapyPreferences == therapyPreferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullName,
      profilePicUrl,
      dateOfBirth,
      genderIdentity,
      preferredPronouns,
      email,
      phoneNumber,
      location,
      emergencyContact,
      therapyPreferences);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(
      this,
    );
  }
}

abstract class _UserProfileModel implements UserProfileModel {
  factory _UserProfileModel(
          {@HiveField(0) final int? id,
          @HiveField(1) final String? fullName,
          @HiveField(2) final String? profilePicUrl,
          @HiveField(3) final DateTime? dateOfBirth,
          @HiveField(4) final String? genderIdentity,
          @HiveField(5) final String? preferredPronouns,
          @HiveField(6) final String? email,
          @HiveField(7) final String? phoneNumber,
          @HiveField(8) final String? location,
          @HiveField(9) final EmergenyContactModel? emergencyContact,
          @HiveField(10) final TherapyPreferencesModel? therapyPreferences}) =
      _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  @HiveField(0)
  int? get id;
  @override
  @HiveField(1)
  String? get fullName;
  @override
  @HiveField(2)
  String? get profilePicUrl;
  @override
  @HiveField(3)
  DateTime? get dateOfBirth;
  @override
  @HiveField(4)
  String? get genderIdentity;
  @override
  @HiveField(5)
  String? get preferredPronouns;
  @override
  @HiveField(6)
  String? get email;
  @override
  @HiveField(7)
  String? get phoneNumber;
  @override
  @HiveField(8)
  String? get location;
  @override
  @HiveField(9)
  EmergenyContactModel? get emergencyContact;
  @override
  @HiveField(10)
  TherapyPreferencesModel? get therapyPreferences;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
