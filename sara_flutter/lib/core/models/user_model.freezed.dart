// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get saudiId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nameEn => throw _privateConstructorUsedError;
  String get birthDate => throw _privateConstructorUsedError;
  String get nationality => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get scenario =>
      throw _privateConstructorUsedError; // safe_gate, in_saudi, elder, guest
  List<ServiceModel> get services => throw _privateConstructorUsedError;
  List<NotificationModel> get notifications =>
      throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String saudiId,
    String name,
    String? nameEn,
    String birthDate,
    String nationality,
    String city,
    String? phone,
    String scenario,
    List<ServiceModel> services,
    List<NotificationModel> notifications,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saudiId = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? birthDate = null,
    Object? nationality = null,
    Object? city = null,
    Object? phone = freezed,
    Object? scenario = null,
    Object? services = null,
    Object? notifications = null,
  }) {
    return _then(
      _value.copyWith(
            saudiId: null == saudiId
                ? _value.saudiId
                : saudiId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            nameEn: freezed == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String?,
            birthDate: null == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as String,
            nationality: null == nationality
                ? _value.nationality
                : nationality // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            scenario: null == scenario
                ? _value.scenario
                : scenario // ignore: cast_nullable_to_non_nullable
                      as String,
            services: null == services
                ? _value.services
                : services // ignore: cast_nullable_to_non_nullable
                      as List<ServiceModel>,
            notifications: null == notifications
                ? _value.notifications
                : notifications // ignore: cast_nullable_to_non_nullable
                      as List<NotificationModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String saudiId,
    String name,
    String? nameEn,
    String birthDate,
    String nationality,
    String city,
    String? phone,
    String scenario,
    List<ServiceModel> services,
    List<NotificationModel> notifications,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saudiId = null,
    Object? name = null,
    Object? nameEn = freezed,
    Object? birthDate = null,
    Object? nationality = null,
    Object? city = null,
    Object? phone = freezed,
    Object? scenario = null,
    Object? services = null,
    Object? notifications = null,
  }) {
    return _then(
      _$UserModelImpl(
        saudiId: null == saudiId
            ? _value.saudiId
            : saudiId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        nameEn: freezed == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String?,
        birthDate: null == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as String,
        nationality: null == nationality
            ? _value.nationality
            : nationality // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        scenario: null == scenario
            ? _value.scenario
            : scenario // ignore: cast_nullable_to_non_nullable
                  as String,
        services: null == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
                  as List<ServiceModel>,
        notifications: null == notifications
            ? _value._notifications
            : notifications // ignore: cast_nullable_to_non_nullable
                  as List<NotificationModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.saudiId,
    required this.name,
    this.nameEn,
    required this.birthDate,
    required this.nationality,
    required this.city,
    this.phone,
    required this.scenario,
    final List<ServiceModel> services = const [],
    final List<NotificationModel> notifications = const [],
  }) : _services = services,
       _notifications = notifications;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String saudiId;
  @override
  final String name;
  @override
  final String? nameEn;
  @override
  final String birthDate;
  @override
  final String nationality;
  @override
  final String city;
  @override
  final String? phone;
  @override
  final String scenario;
  // safe_gate, in_saudi, elder, guest
  final List<ServiceModel> _services;
  // safe_gate, in_saudi, elder, guest
  @override
  @JsonKey()
  List<ServiceModel> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  final List<NotificationModel> _notifications;
  @override
  @JsonKey()
  List<NotificationModel> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  String toString() {
    return 'UserModel(saudiId: $saudiId, name: $name, nameEn: $nameEn, birthDate: $birthDate, nationality: $nationality, city: $city, phone: $phone, scenario: $scenario, services: $services, notifications: $notifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.saudiId, saudiId) || other.saudiId == saudiId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.scenario, scenario) ||
                other.scenario == scenario) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            const DeepCollectionEquality().equals(
              other._notifications,
              _notifications,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    saudiId,
    name,
    nameEn,
    birthDate,
    nationality,
    city,
    phone,
    scenario,
    const DeepCollectionEquality().hash(_services),
    const DeepCollectionEquality().hash(_notifications),
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String saudiId,
    required final String name,
    final String? nameEn,
    required final String birthDate,
    required final String nationality,
    required final String city,
    final String? phone,
    required final String scenario,
    final List<ServiceModel> services,
    final List<NotificationModel> notifications,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get saudiId;
  @override
  String get name;
  @override
  String? get nameEn;
  @override
  String get birthDate;
  @override
  String get nationality;
  @override
  String get city;
  @override
  String? get phone;
  @override
  String get scenario; // safe_gate, in_saudi, elder, guest
  @override
  List<ServiceModel> get services;
  @override
  List<NotificationModel> get notifications;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
