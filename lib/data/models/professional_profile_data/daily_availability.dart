import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_availability.freezed.dart';
part 'daily_availability.g.dart';

@freezed
class DailyAvailability with _$DailyAvailability {
  factory DailyAvailability({
    final String? sunday,
    final String? saturday,
    final String? tuesday,
    final String? friday,
    final String? thursday,
    final String? wednesday,
    final String? monday,
  }) = _DailyAvailability;

  factory DailyAvailability.fromJson(Map<String, dynamic> json) => _$DailyAvailabilityFromJson(json);
}
