import 'package:freezed_annotation/freezed_annotation.dart';
import 'service_model.dart';
import 'notification_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String saudiId,
    required String name,
    String? nameEn,
    required String birthDate,
    required String nationality,
    required String city,
    String? phone,
    required String scenario, // safe_gate, in_saudi, elder, guest
    @Default([]) List<ServiceModel> services,
    @Default([]) List<NotificationModel> notifications,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
