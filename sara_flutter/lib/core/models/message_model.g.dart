// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: (json['id'] as num).toInt(),
      role: json['role'] as String,
      text: json['text'] as String,
      ctas: (json['ctas'] as List<dynamic>?)
          ?.map((e) => CTAAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'text': instance.text,
      'ctas': instance.ctas,
    };

_$CTAActionImpl _$$CTAActionImplFromJson(Map<String, dynamic> json) =>
    _$CTAActionImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      action: json['action'] as String,
      variant: json['variant'] as String? ?? 'secondary',
    );

Map<String, dynamic> _$$CTAActionImplToJson(_$CTAActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'action': instance.action,
      'variant': instance.variant,
    };
