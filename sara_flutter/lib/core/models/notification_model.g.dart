// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: (json['id'] as num).toInt(),
  titleAr: json['titleAr'] as String,
  messageAr: json['messageAr'] as String,
  date: json['date'] as String,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'titleAr': instance.titleAr,
  'messageAr': instance.messageAr,
  'date': instance.date,
};
