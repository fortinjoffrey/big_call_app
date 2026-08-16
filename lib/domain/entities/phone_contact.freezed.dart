// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhoneContact {

 String get id; String get displayName; List<ContactNumber> get numbers; bool get isFavorite;
/// Create a copy of PhoneContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneContactCopyWith<PhoneContact> get copyWith => _$PhoneContactCopyWithImpl<PhoneContact>(this as PhoneContact, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneContact&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.numbers, numbers)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,const DeepCollectionEquality().hash(numbers),isFavorite);

@override
String toString() {
  return 'PhoneContact(id: $id, displayName: $displayName, numbers: $numbers, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $PhoneContactCopyWith<$Res>  {
  factory $PhoneContactCopyWith(PhoneContact value, $Res Function(PhoneContact) _then) = _$PhoneContactCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, List<ContactNumber> numbers, bool isFavorite
});




}
/// @nodoc
class _$PhoneContactCopyWithImpl<$Res>
    implements $PhoneContactCopyWith<$Res> {
  _$PhoneContactCopyWithImpl(this._self, this._then);

  final PhoneContact _self;
  final $Res Function(PhoneContact) _then;

/// Create a copy of PhoneContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? numbers = null,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,numbers: null == numbers ? _self.numbers : numbers // ignore: cast_nullable_to_non_nullable
as List<ContactNumber>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneContact].
extension PhoneContactPatterns on PhoneContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneContact value)  $default,){
final _that = this;
switch (_that) {
case _PhoneContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneContact value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  List<ContactNumber> numbers,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneContact() when $default != null:
return $default(_that.id,_that.displayName,_that.numbers,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  List<ContactNumber> numbers,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _PhoneContact():
return $default(_that.id,_that.displayName,_that.numbers,_that.isFavorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  List<ContactNumber> numbers,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _PhoneContact() when $default != null:
return $default(_that.id,_that.displayName,_that.numbers,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc


class _PhoneContact extends PhoneContact {
  const _PhoneContact({required this.id, required this.displayName, required final  List<ContactNumber> numbers, required this.isFavorite}): _numbers = numbers,super._();
  

@override final  String id;
@override final  String displayName;
 final  List<ContactNumber> _numbers;
@override List<ContactNumber> get numbers {
  if (_numbers is EqualUnmodifiableListView) return _numbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_numbers);
}

@override final  bool isFavorite;

/// Create a copy of PhoneContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneContactCopyWith<_PhoneContact> get copyWith => __$PhoneContactCopyWithImpl<_PhoneContact>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneContact&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other._numbers, _numbers)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,const DeepCollectionEquality().hash(_numbers),isFavorite);

@override
String toString() {
  return 'PhoneContact(id: $id, displayName: $displayName, numbers: $numbers, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$PhoneContactCopyWith<$Res> implements $PhoneContactCopyWith<$Res> {
  factory _$PhoneContactCopyWith(_PhoneContact value, $Res Function(_PhoneContact) _then) = __$PhoneContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, List<ContactNumber> numbers, bool isFavorite
});




}
/// @nodoc
class __$PhoneContactCopyWithImpl<$Res>
    implements _$PhoneContactCopyWith<$Res> {
  __$PhoneContactCopyWithImpl(this._self, this._then);

  final _PhoneContact _self;
  final $Res Function(_PhoneContact) _then;

/// Create a copy of PhoneContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? numbers = null,Object? isFavorite = null,}) {
  return _then(_PhoneContact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,numbers: null == numbers ? _self._numbers : numbers // ignore: cast_nullable_to_non_nullable
as List<ContactNumber>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
