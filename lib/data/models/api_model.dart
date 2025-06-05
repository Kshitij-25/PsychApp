import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_model.freezed.dart';
part 'api_model.g.dart';

@freezed
class ApiModel with _$ApiModel {
  factory ApiModel({
    final String? message,
    @JsonKey(name: 'status') final int? statusCode,
  }) = _ApiModel;

  factory ApiModel.fromJson(Map<String, dynamic> json) => _$ApiModelFromJson(json);
}
