// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      saudiId: json['saudiId'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String?,
      birthDate: json['birthDate'] as String,
      nationality: json['nationality'] as String,
      city: json['city'] as String,
      phone: json['phone'] as String?,
      scenario: json['scenario'] as String,
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notifications:
          (json['notifications'] as List<dynamic>?)
              ?.map(
                (e) => NotificationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'saudiId': instance.saudiId,
      'name': instance.name,
      'nameEn': instance.nameEn,
      'birthDate': instance.birthDate,
      'nationality': instance.nationality,
      'city': instance.city,
      'phone': instance.phone,
      'scenario': instance.scenario,
      'services': instance.services,
      'notifications': instance.notifications,
    };
