// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'education_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EducationHistoryModel _$EducationHistoryModelFromJson(
    Map<String, dynamic> json) {
  return _EducationHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$EducationHistoryModel {
  String? get degree => throw _privateConstructorUsedError;
  String? get institution => throw _privateConstructorUsedError;
  int? get graduationYear => throw _privateConstructorUsedError;
  String? get specializations => throw _privateConstructorUsedError;
  List<String>? get specializationsList => throw _privateConstructorUsedError;

  /// Serializes this EducationHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EducationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EducationHistoryModelCopyWith<EducationHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EducationHistoryModelCopyWith<$Res> {
  factory $EducationHistoryModelCopyWith(EducationHistoryModel value,
          $Res Function(EducationHistoryModel) then) =
      _$EducationHistoryModelCopyWithImpl<$Res, EducationHistoryModel>;
  @useResult
  $Res call(
      {String? degree,
      String? institution,
      int? graduationYear,
      String? specializations,
      List<String>? specializationsList});
}

/// @nodoc
class _$EducationHistoryModelCopyWithImpl<$Res,
        $Val extends EducationHistoryModel>
    implements $EducationHistoryModelCopyWith<$Res> {
  _$EducationHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EducationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? degree = freezed,
    Object? institution = freezed,
    Object? graduationYear = freezed,
    Object? specializations = freezed,
    Object? specializationsList = freezed,
  }) {
    return _then(_value.copyWith(
      degree: freezed == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String?,
      institution: freezed == institution
          ? _value.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as String?,
      graduationYear: freezed == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      specializations: freezed == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as String?,
      specializationsList: freezed == specializationsList
          ? _value.specializationsList
          : specializationsList // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EducationHistoryModelImplCopyWith<$Res>
    implements $EducationHistoryModelCopyWith<$Res> {
  factory _$$EducationHistoryModelImplCopyWith(
          _$EducationHistoryModelImpl value,
          $Res Function(_$EducationHistoryModelImpl) then) =
      __$$EducationHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? degree,
      String? institution,
      int? graduationYear,
      String? specializations,
      List<String>? specializationsList});
}

/// @nodoc
class __$$EducationHistoryModelImplCopyWithImpl<$Res>
    extends _$EducationHistoryModelCopyWithImpl<$Res,
        _$EducationHistoryModelImpl>
    implements _$$EducationHistoryModelImplCopyWith<$Res> {
  __$$EducationHistoryModelImplCopyWithImpl(_$EducationHistoryModelImpl _value,
      $Res Function(_$EducationHistoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EducationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? degree = freezed,
    Object? institution = freezed,
    Object? graduationYear = freezed,
    Object? specializations = freezed,
    Object? specializationsList = freezed,
  }) {
    return _then(_$EducationHistoryModelImpl(
      degree: freezed == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String?,
      institution: freezed == institution
          ? _value.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as String?,
      graduationYear: freezed == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      specializations: freezed == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as String?,
      specializationsList: freezed == specializationsList
          ? _value._specializationsList
          : specializationsList // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EducationHistoryModelImpl implements _EducationHistoryModel {
  _$EducationHistoryModelImpl(
      {this.degree,
      this.institution,
      this.graduationYear,
      this.specializations,
      final List<String>? specializationsList})
      : _specializationsList = specializationsList;

  factory _$EducationHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EducationHistoryModelImplFromJson(json);

  @override
  final String? degree;
  @override
  final String? institution;
  @override
  final int? graduationYear;
  @override
  final String? specializations;
  final List<String>? _specializationsList;
  @override
  List<String>? get specializationsList {
    final value = _specializationsList;
    if (value == null) return null;
    if (_specializationsList is EqualUnmodifiableListView)
      return _specializationsList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'EducationHistoryModel(degree: $degree, institution: $institution, graduationYear: $graduationYear, specializations: $specializations, specializationsList: $specializationsList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EducationHistoryModelImpl &&
            (identical(other.degree, degree) || other.degree == degree) &&
            (identical(other.institution, institution) ||
                other.institution == institution) &&
            (identical(other.graduationYear, graduationYear) ||
                other.graduationYear == graduationYear) &&
            (identical(other.specializations, specializations) ||
                other.specializations == specializations) &&
            const DeepCollectionEquality()
                .equals(other._specializationsList, _specializationsList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      degree,
      institution,
      graduationYear,
      specializations,
      const DeepCollectionEquality().hash(_specializationsList));

  /// Create a copy of EducationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EducationHistoryModelImplCopyWith<_$EducationHistoryModelImpl>
      get copyWith => __$$EducationHistoryModelImplCopyWithImpl<
          _$EducationHistoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EducationHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _EducationHistoryModel implements EducationHistoryModel {
  factory _EducationHistoryModel(
      {final String? degree,
      final String? institution,
      final int? graduationYear,
      final String? specializations,
      final List<String>? specializationsList}) = _$EducationHistoryModelImpl;

  factory _EducationHistoryModel.fromJson(Map<String, dynamic> json) =
      _$EducationHistoryModelImpl.fromJson;

  @override
  String? get degree;
  @override
  String? get institution;
  @override
  int? get graduationYear;
  @override
  String? get specializations;
  @override
  List<String>? get specializationsList;

  /// Create a copy of EducationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EducationHistoryModelImplCopyWith<_$EducationHistoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
