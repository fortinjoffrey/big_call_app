// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 AppPalette get palette; TextSize get textSize; ContactLayout get layout; EmergencyStyle get emergencyStyle;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.palette, palette) || other.palette == palette)&&(identical(other.textSize, textSize) || other.textSize == textSize)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.emergencyStyle, emergencyStyle) || other.emergencyStyle == emergencyStyle));
}


@override
int get hashCode => Object.hash(runtimeType,palette,textSize,layout,emergencyStyle);

@override
String toString() {
  return 'AppSettings(palette: $palette, textSize: $textSize, layout: $layout, emergencyStyle: $emergencyStyle)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 AppPalette palette, TextSize textSize, ContactLayout layout, EmergencyStyle emergencyStyle
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? palette = null,Object? textSize = null,Object? layout = null,Object? emergencyStyle = null,}) {
  return _then(_self.copyWith(
palette: null == palette ? _self.palette : palette // ignore: cast_nullable_to_non_nullable
as AppPalette,textSize: null == textSize ? _self.textSize : textSize // ignore: cast_nullable_to_non_nullable
as TextSize,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as ContactLayout,emergencyStyle: null == emergencyStyle ? _self.emergencyStyle : emergencyStyle // ignore: cast_nullable_to_non_nullable
as EmergencyStyle,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppPalette palette,  TextSize textSize,  ContactLayout layout,  EmergencyStyle emergencyStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.palette,_that.textSize,_that.layout,_that.emergencyStyle);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppPalette palette,  TextSize textSize,  ContactLayout layout,  EmergencyStyle emergencyStyle)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.palette,_that.textSize,_that.layout,_that.emergencyStyle);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppPalette palette,  TextSize textSize,  ContactLayout layout,  EmergencyStyle emergencyStyle)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.palette,_that.textSize,_that.layout,_that.emergencyStyle);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({required this.palette, required this.textSize, required this.layout, required this.emergencyStyle});
  

@override final  AppPalette palette;
@override final  TextSize textSize;
@override final  ContactLayout layout;
@override final  EmergencyStyle emergencyStyle;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.palette, palette) || other.palette == palette)&&(identical(other.textSize, textSize) || other.textSize == textSize)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.emergencyStyle, emergencyStyle) || other.emergencyStyle == emergencyStyle));
}


@override
int get hashCode => Object.hash(runtimeType,palette,textSize,layout,emergencyStyle);

@override
String toString() {
  return 'AppSettings(palette: $palette, textSize: $textSize, layout: $layout, emergencyStyle: $emergencyStyle)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 AppPalette palette, TextSize textSize, ContactLayout layout, EmergencyStyle emergencyStyle
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? palette = null,Object? textSize = null,Object? layout = null,Object? emergencyStyle = null,}) {
  return _then(_AppSettings(
palette: null == palette ? _self.palette : palette // ignore: cast_nullable_to_non_nullable
as AppPalette,textSize: null == textSize ? _self.textSize : textSize // ignore: cast_nullable_to_non_nullable
as TextSize,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as ContactLayout,emergencyStyle: null == emergencyStyle ? _self.emergencyStyle : emergencyStyle // ignore: cast_nullable_to_non_nullable
as EmergencyStyle,
  ));
}


}

// dart format on
