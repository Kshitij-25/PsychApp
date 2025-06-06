// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AvailabilityModel _$AvailabilityModelFromJson(Map<String, dynamic> json) {
  return _AvailabilityModel.fromJson(json);
}

/// @nodoc
mixin _$AvailabilityModel {
  DailyAvailability? get dailyAvailability =>
      throw _privateConstructorUsedError;
  String? get timeZone => throw _privateConstructorUsedError;
  bool? get acceptingNewClients => throw _privateConstructorUsedError;

  /// Serializes this AvailabilityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailabilityModelCopyWith<AvailabilityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailabilityModelCopyWith<$Res> {
  factory $AvailabilityModelCopyWith(
          AvailabilityModel value, $Res Function(AvailabilityModel) then) =
      _$AvailabilityModelCopyWithImpl<$Res, AvailabilityModel>;
  @useResult
  $Res call(
      {DailyAvailability? dailyAvailability,
      String? timeZone,
      bool? acceptingNewClients});

  $DailyAvailabilityCopyWith<$Res>? get dailyAvailability;
}

/// @nodoc
class _$AvailabilityModelCopyWithImpl<$Res, $Val extends AvailabilityModel>
    implements $AvailabilityModelCopyWith<$Res> {
  _$AvailabilityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyAvailability = freezed,
    Object? timeZone = freezed,
    Object? acceptingNewClients = freezed,
  }) {
    return _then(_value.copyWith(
      dailyAvailability: freezed == dailyAvailability
          ? _value.dailyAvailability
          : dailyAvailability // ignore: cast_nullable_to_non_nullable
              as DailyAvailability?,
      timeZone: freezed == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptingNewClients: freezed == acceptingNewClients
          ? _value.acceptingNewClients
          : acceptingNewClients // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyAvailabilityCopyWith<$Res>? get dailyAvailability {
    if (_value.dailyAvailability == null) {
      return null;
    }

    return $DailyAvailabilityCopyWith<$Res>(_value.dailyAvailability!, (value) {
      return _then(_value.copyWith(dailyAvailability: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AvailabilityModelImplCopyWith<$Res>
    implements $AvailabilityModelCopyWith<$Res> {
  factory _$$AvailabilityModelImplCopyWith(_$AvailabilityModelImpl value,
          $Res Function(_$AvailabilityModelImpl) then) =
      __$$AvailabilityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DailyAvailability? dailyAvailability,
      String? timeZone,
      bool? acceptingNewClients});

  @override
  $DailyAvailabilityCopyWith<$Res>? get dailyAvailability;
}

/// @nodoc
class __$$AvailabilityModelImplCopyWithImpl<$Res>
    extends _$AvailabilityModelCopyWithImpl<$Res, _$AvailabilityModelImpl>
    implements _$$AvailabilityModelImplCopyWith<$Res> {
  __$$AvailabilityModelImplCopyWithImpl(_$AvailabilityModelImpl _value,
      $Res Function(_$AvailabilityModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyAvailability = freezed,
    Object? timeZone = freezed,
    Object? acceptingNewClients = freezed,
  }) {
    return _then(_$AvailabilityModelImpl(
      dailyAvailability: freezed == dailyAvailability
          ? _value.dailyAvailability
          : dailyAvailability // ignore: cast_nullable_to_non_nullable
              as DailyAvailability?,
      timeZone: freezed == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptingNewClients: freezed == acceptingNewClients
          ? _value.acceptingNewClients
          : acceptingNewClients // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailabilityModelImpl implements _AvailabilityModel {
  _$AvailabilityModelImpl(
      {this.dailyAvailability, this.timeZone, this.acceptingNewClients});

  factory _$AvailabilityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailabilityModelImplFromJson(json);

  @override
  final DailyAvailability? dailyAvailability;
  @override
  final String? timeZone;
  @override
  final bool? acceptingNewClients;

  @override
  String toString() {
    return 'AvailabilityModel(dailyAvailability: $dailyAvailability, timeZone: $timeZone, acceptingNewClients: $acceptingNewClients)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailabilityModelImpl &&
            (identical(other.dailyAvailability, dailyAvailability) ||
                other.dailyAvailability == dailyAvailability) &&
            (identical(other.timeZone, timeZone) ||
                other.timeZone == timeZone) &&
            (identical(other.acceptingNewClients, acceptingNewClients) ||
                other.acceptingNewClients == acceptingNewClients));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, dailyAvailability, timeZone, acceptingNewClients);

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailabilityModelImplCopyWith<_$AvailabilityModelImpl> get copyWith =>
      __$$AvailabilityModelImplCopyWithImpl<_$AvailabilityModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailabilityModelImplToJson(
      this,
    );
  }
}

abstract class _AvailabilityModel implements AvailabilityModel {
  factory _AvailabilityModel(
      {final DailyAvailability? dailyAvailability,
      final String? timeZone,
      final bool? acceptingNewClients}) = _$AvailabilityModelImpl;

  factory _AvailabilityModel.fromJson(Map<String, dynamic> json) =
      _$AvailabilityModelImpl.fromJson;

  @override
  DailyAvailability? get dailyAvailability;
  @override
  String? get timeZone;
  @override
  bool? get acceptingNewClients;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailabilityModelImplCopyWith<_$AvailabilityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
