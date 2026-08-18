// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContactsState()';
}


}

/// @nodoc
class $ContactsStateCopyWith<$Res>  {
$ContactsStateCopyWith(ContactsState _, $Res Function(ContactsState) __);
}


/// Adds pattern-matching-related methods to [ContactsState].
extension ContactsStatePatterns on ContactsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ContactsLoading value)?  loading,TResult Function( ContactsReady value)?  ready,TResult Function( ContactsPermissionDenied value)?  permissionDenied,TResult Function( ContactsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ContactsLoading() when loading != null:
return loading(_that);case ContactsReady() when ready != null:
return ready(_that);case ContactsPermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case ContactsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ContactsLoading value)  loading,required TResult Function( ContactsReady value)  ready,required TResult Function( ContactsPermissionDenied value)  permissionDenied,required TResult Function( ContactsError value)  error,}){
final _that = this;
switch (_that) {
case ContactsLoading():
return loading(_that);case ContactsReady():
return ready(_that);case ContactsPermissionDenied():
return permissionDenied(_that);case ContactsError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ContactsLoading value)?  loading,TResult? Function( ContactsReady value)?  ready,TResult? Function( ContactsPermissionDenied value)?  permissionDenied,TResult? Function( ContactsError value)?  error,}){
final _that = this;
switch (_that) {
case ContactsLoading() when loading != null:
return loading(_that);case ContactsReady() when ready != null:
return ready(_that);case ContactsPermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case ContactsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<PhoneContact> favorites,  List<PhoneContact> others,  bool showFavoritesSection,  Failure? callError)?  ready,TResult Function()?  permissionDenied,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ContactsLoading() when loading != null:
return loading();case ContactsReady() when ready != null:
return ready(_that.favorites,_that.others,_that.showFavoritesSection,_that.callError);case ContactsPermissionDenied() when permissionDenied != null:
return permissionDenied();case ContactsError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<PhoneContact> favorites,  List<PhoneContact> others,  bool showFavoritesSection,  Failure? callError)  ready,required TResult Function()  permissionDenied,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case ContactsLoading():
return loading();case ContactsReady():
return ready(_that.favorites,_that.others,_that.showFavoritesSection,_that.callError);case ContactsPermissionDenied():
return permissionDenied();case ContactsError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<PhoneContact> favorites,  List<PhoneContact> others,  bool showFavoritesSection,  Failure? callError)?  ready,TResult? Function()?  permissionDenied,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case ContactsLoading() when loading != null:
return loading();case ContactsReady() when ready != null:
return ready(_that.favorites,_that.others,_that.showFavoritesSection,_that.callError);case ContactsPermissionDenied() when permissionDenied != null:
return permissionDenied();case ContactsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ContactsLoading implements ContactsState {
  const ContactsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContactsState.loading()';
}


}




/// @nodoc


class ContactsReady implements ContactsState {
  const ContactsReady({required final  List<PhoneContact> favorites, required final  List<PhoneContact> others, required this.showFavoritesSection, this.callError}): _favorites = favorites,_others = others;
  

 final  List<PhoneContact> _favorites;
 List<PhoneContact> get favorites {
  if (_favorites is EqualUnmodifiableListView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favorites);
}

 final  List<PhoneContact> _others;
 List<PhoneContact> get others {
  if (_others is EqualUnmodifiableListView) return _others;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_others);
}

 final  bool showFavoritesSection;
 final  Failure? callError;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactsReadyCopyWith<ContactsReady> get copyWith => _$ContactsReadyCopyWithImpl<ContactsReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsReady&&const DeepCollectionEquality().equals(other._favorites, _favorites)&&const DeepCollectionEquality().equals(other._others, _others)&&(identical(other.showFavoritesSection, showFavoritesSection) || other.showFavoritesSection == showFavoritesSection)&&(identical(other.callError, callError) || other.callError == callError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_favorites),const DeepCollectionEquality().hash(_others),showFavoritesSection,callError);

@override
String toString() {
  return 'ContactsState.ready(favorites: $favorites, others: $others, showFavoritesSection: $showFavoritesSection, callError: $callError)';
}


}

/// @nodoc
abstract mixin class $ContactsReadyCopyWith<$Res> implements $ContactsStateCopyWith<$Res> {
  factory $ContactsReadyCopyWith(ContactsReady value, $Res Function(ContactsReady) _then) = _$ContactsReadyCopyWithImpl;
@useResult
$Res call({
 List<PhoneContact> favorites, List<PhoneContact> others, bool showFavoritesSection, Failure? callError
});


$FailureCopyWith<$Res>? get callError;

}
/// @nodoc
class _$ContactsReadyCopyWithImpl<$Res>
    implements $ContactsReadyCopyWith<$Res> {
  _$ContactsReadyCopyWithImpl(this._self, this._then);

  final ContactsReady _self;
  final $Res Function(ContactsReady) _then;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? favorites = null,Object? others = null,Object? showFavoritesSection = null,Object? callError = freezed,}) {
  return _then(ContactsReady(
favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<PhoneContact>,others: null == others ? _self._others : others // ignore: cast_nullable_to_non_nullable
as List<PhoneContact>,showFavoritesSection: null == showFavoritesSection ? _self.showFavoritesSection : showFavoritesSection // ignore: cast_nullable_to_non_nullable
as bool,callError: freezed == callError ? _self.callError : callError // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get callError {
    if (_self.callError == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.callError!, (value) {
    return _then(_self.copyWith(callError: value));
  });
}
}

/// @nodoc


class ContactsPermissionDenied implements ContactsState {
  const ContactsPermissionDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsPermissionDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContactsState.permissionDenied()';
}


}




/// @nodoc


class ContactsError implements ContactsState {
  const ContactsError(this.failure);
  

 final  Failure failure;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactsErrorCopyWith<ContactsError> get copyWith => _$ContactsErrorCopyWithImpl<ContactsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ContactsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ContactsErrorCopyWith<$Res> implements $ContactsStateCopyWith<$Res> {
  factory $ContactsErrorCopyWith(ContactsError value, $Res Function(ContactsError) _then) = _$ContactsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ContactsErrorCopyWithImpl<$Res>
    implements $ContactsErrorCopyWith<$Res> {
  _$ContactsErrorCopyWithImpl(this._self, this._then);

  final ContactsError _self;
  final $Res Function(ContactsError) _then;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ContactsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
