// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      saudiId: json['saudiId'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      phone: json['phone'] as String,
      scenario: json['scenario'] as String,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'saudiId': instance.saudiId,
      'name': instance.name,
      'city': instance.city,
      'phone': instance.phone,
      'scenario': instance.scenario,
    };
