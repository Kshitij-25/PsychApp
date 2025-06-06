// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'professional_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfessionalProfileModel _$ProfessionalProfileModelFromJson(
    Map<String, dynamic> json) {
  return _ProfessionalProfileModel.fromJson(json);
}

/// @nodoc
mixin _$ProfessionalProfileModel {
  int? get id => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get dateOfBirth => throw _privateConstructorUsedError;
  String? get genderIdentity => throw _privateConstructorUsedError;
  String? get preferredPronouns => throw _privateConstructorUsedError;
  String? get contactNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  CredentialsModel? get credentials => throw _privateConstructorUsedError;
  List<EducationHistoryModel>? get educationHistory =>
      throw _privateConstructorUsedError;
  ExperienceModel? get experience => throw _privateConstructorUsedError;
  List<String>? get therapeuticModalities => throw _privateConstructorUsedError;
  String? get therapyDescription => throw _privateConstructorUsedError;
  AvailabilityModel? get availability => throw _privateConstructorUsedError;
  PaymentInfoModel? get paymentInfo => throw _privateConstructorUsedError;
  bool? get backgroundCheckConsent => throw _privateConstructorUsedError;
  bool? get termsAccepted => throw _privateConstructorUsedError;
  Documents? get documents => throw _privateConstructorUsedError;

  /// Serializes this ProfessionalProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfessionalProfileModelCopyWith<ProfessionalProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfessionalProfileModelCopyWith<$Res> {
  factory $ProfessionalProfileModelCopyWith(ProfessionalProfileModel value,
          $Res Function(ProfessionalProfileModel) then) =
      _$ProfessionalProfileModelCopyWithImpl<$Res, ProfessionalProfileModel>;
  @useResult
  $Res call(
      {int? id,
      String? fullName,
      String? profileImageUrl,
      String? dateOfBirth,
      String? genderIdentity,
      String? preferredPronouns,
      String? contactNumber,
      String? email,
      String? address,
      CredentialsModel? credentials,
      List<EducationHistoryModel>? educationHistory,
      ExperienceModel? experience,
      List<String>? therapeuticModalities,
      String? therapyDescription,
      AvailabilityModel? availability,
      PaymentInfoModel? paymentInfo,
      bool? backgroundCheckConsent,
      bool? termsAccepted,
      Documents? documents});

  $CredentialsModelCopyWith<$Res>? get credentials;
  $ExperienceModelCopyWith<$Res>? get experience;
  $AvailabilityModelCopyWith<$Res>? get availability;
  $PaymentInfoModelCopyWith<$Res>? get paymentInfo;
}

/// @nodoc
class _$ProfessionalProfileModelCopyWithImpl<$Res,
        $Val extends ProfessionalProfileModel>
    implements $ProfessionalProfileModelCopyWith<$Res> {
  _$ProfessionalProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = freezed,
    Object? profileImageUrl = freezed,
    Object? dateOfBirth = freezed,
    Object? genderIdentity = freezed,
    Object? preferredPronouns = freezed,
    Object? contactNumber = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? credentials = freezed,
    Object? educationHistory = freezed,
    Object? experience = freezed,
    Object? therapeuticModalities = freezed,
    Object? therapyDescription = freezed,
    Object? availability = freezed,
    Object? paymentInfo = freezed,
    Object? backgroundCheckConsent = freezed,
    Object? termsAccepted = freezed,
    Object? documents = freezed,
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
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      genderIdentity: freezed == genderIdentity
          ? _value.genderIdentity
          : genderIdentity // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredPronouns: freezed == preferredPronouns
          ? _value.preferredPronouns
          : preferredPronouns // ignore: cast_nullable_to_non_nullable
              as String?,
      contactNumber: freezed == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      credentials: freezed == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as CredentialsModel?,
      educationHistory: freezed == educationHistory
          ? _value.educationHistory
          : educationHistory // ignore: cast_nullable_to_non_nullable
              as List<EducationHistoryModel>?,
      experience: freezed == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as ExperienceModel?,
      therapeuticModalities: freezed == therapeuticModalities
          ? _value.therapeuticModalities
          : therapeuticModalities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      therapyDescription: freezed == therapyDescription
          ? _value.therapyDescription
          : therapyDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as AvailabilityModel?,
      paymentInfo: freezed == paymentInfo
          ? _value.paymentInfo
          : paymentInfo // ignore: cast_nullable_to_non_nullable
              as PaymentInfoModel?,
      backgroundCheckConsent: freezed == backgroundCheckConsent
          ? _value.backgroundCheckConsent
          : backgroundCheckConsent // ignore: cast_nullable_to_non_nullable
              as bool?,
      termsAccepted: freezed == termsAccepted
          ? _value.termsAccepted
          : termsAccepted // ignore: cast_nullable_to_non_nullable
              as bool?,
      documents: freezed == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as Documents?,
    ) as $Val);
  }

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CredentialsModelCopyWith<$Res>? get credentials {
    if (_value.credentials == null) {
      return null;
    }

    return $CredentialsModelCopyWith<$Res>(_value.credentials!, (value) {
      return _then(_value.copyWith(credentials: value) as $Val);
    });
  }

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExperienceModelCopyWith<$Res>? get experience {
    if (_value.experience == null) {
      return null;
    }

    return $ExperienceModelCopyWith<$Res>(_value.experience!, (value) {
      return _then(_value.copyWith(experience: value) as $Val);
    });
  }

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvailabilityModelCopyWith<$Res>? get availability {
    if (_value.availability == null) {
      return null;
    }

    return $AvailabilityModelCopyWith<$Res>(_value.availability!, (value) {
      return _then(_value.copyWith(availability: value) as $Val);
    });
  }

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentInfoModelCopyWith<$Res>? get paymentInfo {
    if (_value.paymentInfo == null) {
      return null;
    }

    return $PaymentInfoModelCopyWith<$Res>(_value.paymentInfo!, (value) {
      return _then(_value.copyWith(paymentInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfessionalProfileModelImplCopyWith<$Res>
    implements $ProfessionalProfileModelCopyWith<$Res> {
  factory _$$ProfessionalProfileModelImplCopyWith(
          _$ProfessionalProfileModelImpl value,
          $Res Function(_$ProfessionalProfileModelImpl) then) =
      __$$ProfessionalProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? fullName,
      String? profileImageUrl,
      String? dateOfBirth,
      String? genderIdentity,
      String? preferredPronouns,
      String? contactNumber,
      String? email,
      String? address,
      CredentialsModel? credentials,
      List<EducationHistoryModel>? educationHistory,
      ExperienceModel? experience,
      List<String>? therapeuticModalities,
      String? therapyDescription,
      AvailabilityModel? availability,
      PaymentInfoModel? paymentInfo,
      bool? backgroundCheckConsent,
      bool? termsAccepted,
      Documents? documents});

  @override
  $CredentialsModelCopyWith<$Res>? get credentials;
  @override
  $ExperienceModelCopyWith<$Res>? get experience;
  @override
  $AvailabilityModelCopyWith<$Res>? get availability;
  @override
  $PaymentInfoModelCopyWith<$Res>? get paymentInfo;
}

/// @nodoc
class __$$ProfessionalProfileModelImplCopyWithImpl<$Res>
    extends _$ProfessionalProfileModelCopyWithImpl<$Res,
        _$ProfessionalProfileModelImpl>
    implements _$$ProfessionalProfileModelImplCopyWith<$Res> {
  __$$ProfessionalProfileModelImplCopyWithImpl(
      _$ProfessionalProfileModelImpl _value,
      $Res Function(_$ProfessionalProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = freezed,
    Object? profileImageUrl = freezed,
    Object? dateOfBirth = freezed,
    Object? genderIdentity = freezed,
    Object? preferredPronouns = freezed,
    Object? contactNumber = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? credentials = freezed,
    Object? educationHistory = freezed,
    Object? experience = freezed,
    Object? therapeuticModalities = freezed,
    Object? therapyDescription = freezed,
    Object? availability = freezed,
    Object? paymentInfo = freezed,
    Object? backgroundCheckConsent = freezed,
    Object? termsAccepted = freezed,
    Object? documents = freezed,
  }) {
    return _then(_$ProfessionalProfileModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      genderIdentity: freezed == genderIdentity
          ? _value.genderIdentity
          : genderIdentity // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredPronouns: freezed == preferredPronouns
          ? _value.preferredPronouns
          : preferredPronouns // ignore: cast_nullable_to_non_nullable
              as String?,
      contactNumber: freezed == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      credentials: freezed == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as CredentialsModel?,
      educationHistory: freezed == educationHistory
          ? _value._educationHistory
          : educationHistory // ignore: cast_nullable_to_non_nullable
              as List<EducationHistoryModel>?,
      experience: freezed == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as ExperienceModel?,
      therapeuticModalities: freezed == therapeuticModalities
          ? _value._therapeuticModalities
          : therapeuticModalities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      therapyDescription: freezed == therapyDescription
          ? _value.therapyDescription
          : therapyDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as AvailabilityModel?,
      paymentInfo: freezed == paymentInfo
          ? _value.paymentInfo
          : paymentInfo // ignore: cast_nullable_to_non_nullable
              as PaymentInfoModel?,
      backgroundCheckConsent: freezed == backgroundCheckConsent
          ? _value.backgroundCheckConsent
          : backgroundCheckConsent // ignore: cast_nullable_to_non_nullable
              as bool?,
      termsAccepted: freezed == termsAccepted
          ? _value.termsAccepted
          : termsAccepted // ignore: cast_nullable_to_non_nullable
              as bool?,
      documents: freezed == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as Documents?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfessionalProfileModelImpl implements _ProfessionalProfileModel {
  _$ProfessionalProfileModelImpl(
      {this.id,
      this.fullName,
      this.profileImageUrl,
      this.dateOfBirth,
      this.genderIdentity,
      this.preferredPronouns,
      this.contactNumber,
      this.email,
      this.address,
      this.credentials,
      final List<EducationHistoryModel>? educationHistory,
      this.experience,
      final List<String>? therapeuticModalities,
      this.therapyDescription,
      this.availability,
      this.paymentInfo,
      this.backgroundCheckConsent,
      this.termsAccepted,
      this.documents})
      : _educationHistory = educationHistory,
        _therapeuticModalities = therapeuticModalities;

  factory _$ProfessionalProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfessionalProfileModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? fullName;
  @override
  final String? profileImageUrl;
  @override
  final String? dateOfBirth;
  @override
  final String? genderIdentity;
  @override
  final String? preferredPronouns;
  @override
  final String? contactNumber;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final CredentialsModel? credentials;
  final List<EducationHistoryModel>? _educationHistory;
  @override
  List<EducationHistoryModel>? get educationHistory {
    final value = _educationHistory;
    if (value == null) return null;
    if (_educationHistory is EqualUnmodifiableListView)
      return _educationHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ExperienceModel? experience;
  final List<String>? _therapeuticModalities;
  @override
  List<String>? get therapeuticModalities {
    final value = _therapeuticModalities;
    if (value == null) return null;
    if (_therapeuticModalities is EqualUnmodifiableListView)
      return _therapeuticModalities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? therapyDescription;
  @override
  final AvailabilityModel? availability;
  @override
  final PaymentInfoModel? paymentInfo;
  @override
  final bool? backgroundCheckConsent;
  @override
  final bool? termsAccepted;
  @override
  final Documents? documents;

  @override
  String toString() {
    return 'ProfessionalProfileModel(id: $id, fullName: $fullName, profileImageUrl: $profileImageUrl, dateOfBirth: $dateOfBirth, genderIdentity: $genderIdentity, preferredPronouns: $preferredPronouns, contactNumber: $contactNumber, email: $email, address: $address, credentials: $credentials, educationHistory: $educationHistory, experience: $experience, therapeuticModalities: $therapeuticModalities, therapyDescription: $therapyDescription, availability: $availability, paymentInfo: $paymentInfo, backgroundCheckConsent: $backgroundCheckConsent, termsAccepted: $termsAccepted, documents: $documents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfessionalProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.genderIdentity, genderIdentity) ||
                other.genderIdentity == genderIdentity) &&
            (identical(other.preferredPronouns, preferredPronouns) ||
                other.preferredPronouns == preferredPronouns) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.credentials, credentials) ||
                other.credentials == credentials) &&
            const DeepCollectionEquality()
                .equals(other._educationHistory, _educationHistory) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            const DeepCollectionEquality()
                .equals(other._therapeuticModalities, _therapeuticModalities) &&
            (identical(other.therapyDescription, therapyDescription) ||
                other.therapyDescription == therapyDescription) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.paymentInfo, paymentInfo) ||
                other.paymentInfo == paymentInfo) &&
            (identical(other.backgroundCheckConsent, backgroundCheckConsent) ||
                other.backgroundCheckConsent == backgroundCheckConsent) &&
            (identical(other.termsAccepted, termsAccepted) ||
                other.termsAccepted == termsAccepted) &&
            (identical(other.documents, documents) ||
                other.documents == documents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        fullName,
        profileImageUrl,
        dateOfBirth,
        genderIdentity,
        preferredPronouns,
        contactNumber,
        email,
        address,
        credentials,
        const DeepCollectionEquality().hash(_educationHistory),
        experience,
        const DeepCollectionEquality().hash(_therapeuticModalities),
        therapyDescription,
        availability,
        paymentInfo,
        backgroundCheckConsent,
        termsAccepted,
        documents
      ]);

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfessionalProfileModelImplCopyWith<_$ProfessionalProfileModelImpl>
      get copyWith => __$$ProfessionalProfileModelImplCopyWithImpl<
          _$ProfessionalProfileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfessionalProfileModelImplToJson(
      this,
    );
  }
}

abstract class _ProfessionalProfileModel implements ProfessionalProfileModel {
  factory _ProfessionalProfileModel(
      {final int? id,
      final String? fullName,
      final String? profileImageUrl,
      final String? dateOfBirth,
      final String? genderIdentity,
      final String? preferredPronouns,
      final String? contactNumber,
      final String? email,
      final String? address,
      final CredentialsModel? credentials,
      final List<EducationHistoryModel>? educationHistory,
      final ExperienceModel? experience,
      final List<String>? therapeuticModalities,
      final String? therapyDescription,
      final AvailabilityModel? availability,
      final PaymentInfoModel? paymentInfo,
      final bool? backgroundCheckConsent,
      final bool? termsAccepted,
      final Documents? documents}) = _$ProfessionalProfileModelImpl;

  factory _ProfessionalProfileModel.fromJson(Map<String, dynamic> json) =
      _$ProfessionalProfileModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get fullName;
  @override
  String? get profileImageUrl;
  @override
  String? get dateOfBirth;
  @override
  String? get genderIdentity;
  @override
  String? get preferredPronouns;
  @override
  String? get contactNumber;
  @override
  String? get email;
  @override
  String? get address;
  @override
  CredentialsModel? get credentials;
  @override
  List<EducationHistoryModel>? get educationHistory;
  @override
  ExperienceModel? get experience;
  @override
  List<String>? get therapeuticModalities;
  @override
  String? get therapyDescription;
  @override
  AvailabilityModel? get availability;
  @override
  PaymentInfoModel? get paymentInfo;
  @override
  bool? get backgroundCheckConsent;
  @override
  bool? get termsAccepted;
  @override
  Documents? get documents;

  /// Create a copy of ProfessionalProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfessionalProfileModelImplCopyWith<_$ProfessionalProfileModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
