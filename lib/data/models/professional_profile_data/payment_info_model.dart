import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_info_model.freezed.dart';
part 'payment_info_model.g.dart';

@freezed
class PaymentInfoModel with _$PaymentInfoModel {
  factory PaymentInfoModel({
    final bool? acceptsInsurance,
    final List<String>? acceptedInsurances,
    final String? sessionFees,
    final bool? slidingScaleAvailable,
  }) = _PaymentInfoModel;

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) => _$PaymentInfoModelFromJson(json);
}
