import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required int id,
    required String role, // 'user' or 'assistant'
    required String text,
    List<CTAAction>? ctas,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

@freezed
class CTAAction with _$CTAAction {
  const factory CTAAction({
    required String id,
    required String label,
    required String action,
    @Default('secondary') String variant, // 'primary' or 'secondary'
  }) = _CTAAction;

  factory CTAAction.fromJson(Map<String, dynamic> json) =>
      _$CTAActionFromJson(json);
}
