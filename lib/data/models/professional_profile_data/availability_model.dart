import 'package:freezed_annotation/freezed_annotation.dart';

import 'daily_availability.dart';

part 'availability_model.freezed.dart';
part 'availability_model.g.dart';

@freezed
class AvailabilityModel with _$AvailabilityModel {
  factory AvailabilityModel({
    DailyAvailability? dailyAvailability,
    String? timeZone,
    bool? acceptingNewClients,
  }) = _AvailabilityModel;

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) => _$AvailabilityModelFromJson(json);
}
