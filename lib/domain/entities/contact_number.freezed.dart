// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_number.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactNumber {

 String get number;/// Libellé déjà traduit en français : « Mobile », « Fixe », « Bureau »…
 String get label;
/// Create a copy of ContactNumber
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactNumberCopyWith<ContactNumber> get copyWith => _$ContactNumberCopyWithImpl<ContactNumber>(this as ContactNumber, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactNumber&&(identical(other.number, number) || other.number == number)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,number,label);

@override
String toString() {
  return 'ContactNumber(number: $number, label: $label)';
}


}

/// @nodoc
abstract mixin class $ContactNumberCopyWith<$Res>  {
  factory $ContactNumberCopyWith(ContactNumber value, $Res Function(ContactNumber) _then) = _$ContactNumberCopyWithImpl;
@useResult
$Res call({
 String number, String label
});




}
/// @nodoc
class _$ContactNumberCopyWithImpl<$Res>
    implements $ContactNumberCopyWith<$Res> {
  _$ContactNumberCopyWithImpl(this._self, this._then);

  final ContactNumber _self;
  final $Res Function(ContactNumber) _then;

/// Create a copy of ContactNumber
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? label = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactNumber].
extension ContactNumberPatterns on ContactNumber {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactNumber value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactNumber() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactNumber value)  $default,){
final _that = this;
switch (_that) {
case _ContactNumber():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactNumber value)?  $default,){
final _that = this;
switch (_that) {
case _ContactNumber() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String number,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactNumber() when $default != null:
return $default(_that.number,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String number,  String label)  $default,) {final _that = this;
switch (_that) {
case _ContactNumber():
return $default(_that.number,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String number,  String label)?  $default,) {final _that = this;
switch (_that) {
case _ContactNumber() when $default != null:
return $default(_that.number,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _ContactNumber implements ContactNumber {
  const _ContactNumber({required this.number, required this.label});
  

@override final  String number;
/// Libellé déjà traduit en français : « Mobile », « Fixe », « Bureau »…
@override final  String label;

/// Create a copy of ContactNumber
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactNumberCopyWith<_ContactNumber> get copyWith => __$ContactNumberCopyWithImpl<_ContactNumber>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactNumber&&(identical(other.number, number) || other.number == number)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,number,label);

@override
String toString() {
  return 'ContactNumber(number: $number, label: $label)';
}


}

/// @nodoc
abstract mixin class _$ContactNumberCopyWith<$Res> implements $ContactNumberCopyWith<$Res> {
  factory _$ContactNumberCopyWith(_ContactNumber value, $Res Function(_ContactNumber) _then) = __$ContactNumberCopyWithImpl;
@override @useResult
$Res call({
 String number, String label
});




}
/// @nodoc
class __$ContactNumberCopyWithImpl<$Res>
    implements _$ContactNumberCopyWith<$Res> {
  __$ContactNumberCopyWithImpl(this._self, this._then);

  final _ContactNumber _self;
  final $Res Function(_ContactNumber) _then;

/// Create a copy of ContactNumber
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? label = null,}) {
  return _then(_ContactNumber(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
