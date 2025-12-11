// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtpModelImpl _$$OtpModelImplFromJson(Map<String, dynamic> json) =>
    _$OtpModelImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      sender: json['sender'] as String,
      purpose: json['purpose'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$$OtpModelImplToJson(_$OtpModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'sender': instance.sender,
      'purpose': instance.purpose,
      'time': instance.time,
    };
