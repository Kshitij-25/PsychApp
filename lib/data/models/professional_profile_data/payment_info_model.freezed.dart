// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentInfoModel _$PaymentInfoModelFromJson(Map<String, dynamic> json) {
  return _PaymentInfoModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentInfoModel {
  bool? get acceptsInsurance => throw _privateConstructorUsedError;
  List<String>? get acceptedInsurances => throw _privateConstructorUsedError;
  String? get sessionFees => throw _privateConstructorUsedError;
  bool? get slidingScaleAvailable => throw _privateConstructorUsedError;

  /// Serializes this PaymentInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentInfoModelCopyWith<PaymentInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentInfoModelCopyWith<$Res> {
  factory $PaymentInfoModelCopyWith(
          PaymentInfoModel value, $Res Function(PaymentInfoModel) then) =
      _$PaymentInfoModelCopyWithImpl<$Res, PaymentInfoModel>;
  @useResult
  $Res call(
      {bool? acceptsInsurance,
      List<String>? acceptedInsurances,
      String? sessionFees,
      bool? slidingScaleAvailable});
}

/// @nodoc
class _$PaymentInfoModelCopyWithImpl<$Res, $Val extends PaymentInfoModel>
    implements $PaymentInfoModelCopyWith<$Res> {
  _$PaymentInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptsInsurance = freezed,
    Object? acceptedInsurances = freezed,
    Object? sessionFees = freezed,
    Object? slidingScaleAvailable = freezed,
  }) {
    return _then(_value.copyWith(
      acceptsInsurance: freezed == acceptsInsurance
          ? _value.acceptsInsurance
          : acceptsInsurance // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptedInsurances: freezed == acceptedInsurances
          ? _value.acceptedInsurances
          : acceptedInsurances // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sessionFees: freezed == sessionFees
          ? _value.sessionFees
          : sessionFees // ignore: cast_nullable_to_non_nullable
              as String?,
      slidingScaleAvailable: freezed == slidingScaleAvailable
          ? _value.slidingScaleAvailable
          : slidingScaleAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentInfoModelImplCopyWith<$Res>
    implements $PaymentInfoModelCopyWith<$Res> {
  factory _$$PaymentInfoModelImplCopyWith(_$PaymentInfoModelImpl value,
          $Res Function(_$PaymentInfoModelImpl) then) =
      __$$PaymentInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? acceptsInsurance,
      List<String>? acceptedInsurances,
      String? sessionFees,
      bool? slidingScaleAvailable});
}

/// @nodoc
class __$$PaymentInfoModelImplCopyWithImpl<$Res>
    extends _$PaymentInfoModelCopyWithImpl<$Res, _$PaymentInfoModelImpl>
    implements _$$PaymentInfoModelImplCopyWith<$Res> {
  __$$PaymentInfoModelImplCopyWithImpl(_$PaymentInfoModelImpl _value,
      $Res Function(_$PaymentInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptsInsurance = freezed,
    Object? acceptedInsurances = freezed,
    Object? sessionFees = freezed,
    Object? slidingScaleAvailable = freezed,
  }) {
    return _then(_$PaymentInfoModelImpl(
      acceptsInsurance: freezed == acceptsInsurance
          ? _value.acceptsInsurance
          : acceptsInsurance // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptedInsurances: freezed == acceptedInsurances
          ? _value._acceptedInsurances
          : acceptedInsurances // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sessionFees: freezed == sessionFees
          ? _value.sessionFees
          : sessionFees // ignore: cast_nullable_to_non_nullable
              as String?,
      slidingScaleAvailable: freezed == slidingScaleAvailable
          ? _value.slidingScaleAvailable
          : slidingScaleAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentInfoModelImpl implements _PaymentInfoModel {
  _$PaymentInfoModelImpl(
      {this.acceptsInsurance,
      final List<String>? acceptedInsurances,
      this.sessionFees,
      this.slidingScaleAvailable})
      : _acceptedInsurances = acceptedInsurances;

  factory _$PaymentInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentInfoModelImplFromJson(json);

  @override
  final bool? acceptsInsurance;
  final List<String>? _acceptedInsurances;
  @override
  List<String>? get acceptedInsurances {
    final value = _acceptedInsurances;
    if (value == null) return null;
    if (_acceptedInsurances is EqualUnmodifiableListView)
      return _acceptedInsurances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? sessionFees;
  @override
  final bool? slidingScaleAvailable;

  @override
  String toString() {
    return 'PaymentInfoModel(acceptsInsurance: $acceptsInsurance, acceptedInsurances: $acceptedInsurances, sessionFees: $sessionFees, slidingScaleAvailable: $slidingScaleAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentInfoModelImpl &&
            (identical(other.acceptsInsurance, acceptsInsurance) ||
                other.acceptsInsurance == acceptsInsurance) &&
            const DeepCollectionEquality()
                .equals(other._acceptedInsurances, _acceptedInsurances) &&
            (identical(other.sessionFees, sessionFees) ||
                other.sessionFees == sessionFees) &&
            (identical(other.slidingScaleAvailable, slidingScaleAvailable) ||
                other.slidingScaleAvailable == slidingScaleAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      acceptsInsurance,
      const DeepCollectionEquality().hash(_acceptedInsurances),
      sessionFees,
      slidingScaleAvailable);

  /// Create a copy of PaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentInfoModelImplCopyWith<_$PaymentInfoModelImpl> get copyWith =>
      __$$PaymentInfoModelImplCopyWithImpl<_$PaymentInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentInfoModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentInfoModel implements PaymentInfoModel {
  factory _PaymentInfoModel(
      {final bool? acceptsInsurance,
      final List<String>? acceptedInsurances,
      final String? sessionFees,
      final bool? slidingScaleAvailable}) = _$PaymentInfoModelImpl;

  factory _PaymentInfoModel.fromJson(Map<String, dynamic> json) =
      _$PaymentInfoModelImpl.fromJson;

  @override
  bool? get acceptsInsurance;
  @override
  List<String>? get acceptedInsurances;
  @override
  String? get sessionFees;
  @override
  bool? get slidingScaleAvailable;

  /// Create a copy of PaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentInfoModelImplCopyWith<_$PaymentInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
