// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  int get id => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // 'user' or 'assistant'
  String get text => throw _privateConstructorUsedError;
  List<CTAAction>? get ctas => throw _privateConstructorUsedError;

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
    MessageModel value,
    $Res Function(MessageModel) then,
  ) = _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call({int id, String role, String text, List<CTAAction>? ctas});
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = null,
    Object? ctas = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            ctas: freezed == ctas
                ? _value.ctas
                : ctas // ignore: cast_nullable_to_non_nullable
                      as List<CTAAction>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
    _$MessageModelImpl value,
    $Res Function(_$MessageModelImpl) then,
  ) = __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String role, String text, List<CTAAction>? ctas});
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
    _$MessageModelImpl _value,
    $Res Function(_$MessageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = null,
    Object? ctas = freezed,
  }) {
    return _then(
      _$MessageModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        ctas: freezed == ctas
            ? _value._ctas
            : ctas // ignore: cast_nullable_to_non_nullable
                  as List<CTAAction>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl({
    required this.id,
    required this.role,
    required this.text,
    final List<CTAAction>? ctas,
  }) : _ctas = ctas;

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final int id;
  @override
  final String role;
  // 'user' or 'assistant'
  @override
  final String text;
  final List<CTAAction>? _ctas;
  @override
  List<CTAAction>? get ctas {
    final value = _ctas;
    if (value == null) return null;
    if (_ctas is EqualUnmodifiableListView) return _ctas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, role: $role, text: $text, ctas: $ctas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._ctas, _ctas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    role,
    text,
    const DeepCollectionEquality().hash(_ctas),
  );

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(this);
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel({
    required final int id,
    required final String role,
    required final String text,
    final List<CTAAction>? ctas,
  }) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  int get id;
  @override
  String get role; // 'user' or 'assistant'
  @override
  String get text;
  @override
  List<CTAAction>? get ctas;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CTAAction _$CTAActionFromJson(Map<String, dynamic> json) {
  return _CTAAction.fromJson(json);
}

/// @nodoc
mixin _$CTAAction {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get variant => throw _privateConstructorUsedError;

  /// Serializes this CTAAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CTAAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CTAActionCopyWith<CTAAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CTAActionCopyWith<$Res> {
  factory $CTAActionCopyWith(CTAAction value, $Res Function(CTAAction) then) =
      _$CTAActionCopyWithImpl<$Res, CTAAction>;
  @useResult
  $Res call({String id, String label, String action, String variant});
}

/// @nodoc
class _$CTAActionCopyWithImpl<$Res, $Val extends CTAAction>
    implements $CTAActionCopyWith<$Res> {
  _$CTAActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CTAAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? action = null,
    Object? variant = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String,
            variant: null == variant
                ? _value.variant
                : variant // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CTAActionImplCopyWith<$Res>
    implements $CTAActionCopyWith<$Res> {
  factory _$$CTAActionImplCopyWith(
    _$CTAActionImpl value,
    $Res Function(_$CTAActionImpl) then,
  ) = __$$CTAActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label, String action, String variant});
}

/// @nodoc
class __$$CTAActionImplCopyWithImpl<$Res>
    extends _$CTAActionCopyWithImpl<$Res, _$CTAActionImpl>
    implements _$$CTAActionImplCopyWith<$Res> {
  __$$CTAActionImplCopyWithImpl(
    _$CTAActionImpl _value,
    $Res Function(_$CTAActionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CTAAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? action = null,
    Object? variant = null,
  }) {
    return _then(
      _$CTAActionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        variant: null == variant
            ? _value.variant
            : variant // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CTAActionImpl implements _CTAAction {
  const _$CTAActionImpl({
    required this.id,
    required this.label,
    required this.action,
    this.variant = 'secondary',
  });

  factory _$CTAActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CTAActionImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String action;
  @override
  @JsonKey()
  final String variant;

  @override
  String toString() {
    return 'CTAAction(id: $id, label: $label, action: $action, variant: $variant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CTAActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.variant, variant) || other.variant == variant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, action, variant);

  /// Create a copy of CTAAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CTAActionImplCopyWith<_$CTAActionImpl> get copyWith =>
      __$$CTAActionImplCopyWithImpl<_$CTAActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CTAActionImplToJson(this);
  }
}

abstract class _CTAAction implements CTAAction {
  const factory _CTAAction({
    required final String id,
    required final String label,
    required final String action,
    final String variant,
  }) = _$CTAActionImpl;

  factory _CTAAction.fromJson(Map<String, dynamic> json) =
      _$CTAActionImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String get action;
  @override
  String get variant;

  /// Create a copy of CTAAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CTAActionImplCopyWith<_$CTAActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
