// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GoogleSignInRequested value)?  googleSignInRequested,TResult Function( AppleSignInRequested value)?  appleSignInRequested,TResult Function( LineSignInRequested value)?  lineSignInRequested,TResult Function( LogoutRequested value)?  logoutRequested,TResult Function( AuthCheckRequested value)?  authCheckRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested(_that);case AppleSignInRequested() when appleSignInRequested != null:
return appleSignInRequested(_that);case LineSignInRequested() when lineSignInRequested != null:
return lineSignInRequested(_that);case LogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case AuthCheckRequested() when authCheckRequested != null:
return authCheckRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GoogleSignInRequested value)  googleSignInRequested,required TResult Function( AppleSignInRequested value)  appleSignInRequested,required TResult Function( LineSignInRequested value)  lineSignInRequested,required TResult Function( LogoutRequested value)  logoutRequested,required TResult Function( AuthCheckRequested value)  authCheckRequested,}){
final _that = this;
switch (_that) {
case GoogleSignInRequested():
return googleSignInRequested(_that);case AppleSignInRequested():
return appleSignInRequested(_that);case LineSignInRequested():
return lineSignInRequested(_that);case LogoutRequested():
return logoutRequested(_that);case AuthCheckRequested():
return authCheckRequested(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GoogleSignInRequested value)?  googleSignInRequested,TResult? Function( AppleSignInRequested value)?  appleSignInRequested,TResult? Function( LineSignInRequested value)?  lineSignInRequested,TResult? Function( LogoutRequested value)?  logoutRequested,TResult? Function( AuthCheckRequested value)?  authCheckRequested,}){
final _that = this;
switch (_that) {
case GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested(_that);case AppleSignInRequested() when appleSignInRequested != null:
return appleSignInRequested(_that);case LineSignInRequested() when lineSignInRequested != null:
return lineSignInRequested(_that);case LogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case AuthCheckRequested() when authCheckRequested != null:
return authCheckRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  googleSignInRequested,TResult Function()?  appleSignInRequested,TResult Function()?  lineSignInRequested,TResult Function()?  logoutRequested,TResult Function()?  authCheckRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested();case AppleSignInRequested() when appleSignInRequested != null:
return appleSignInRequested();case LineSignInRequested() when lineSignInRequested != null:
return lineSignInRequested();case LogoutRequested() when logoutRequested != null:
return logoutRequested();case AuthCheckRequested() when authCheckRequested != null:
return authCheckRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  googleSignInRequested,required TResult Function()  appleSignInRequested,required TResult Function()  lineSignInRequested,required TResult Function()  logoutRequested,required TResult Function()  authCheckRequested,}) {final _that = this;
switch (_that) {
case GoogleSignInRequested():
return googleSignInRequested();case AppleSignInRequested():
return appleSignInRequested();case LineSignInRequested():
return lineSignInRequested();case LogoutRequested():
return logoutRequested();case AuthCheckRequested():
return authCheckRequested();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  googleSignInRequested,TResult? Function()?  appleSignInRequested,TResult? Function()?  lineSignInRequested,TResult? Function()?  logoutRequested,TResult? Function()?  authCheckRequested,}) {final _that = this;
switch (_that) {
case GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested();case AppleSignInRequested() when appleSignInRequested != null:
return appleSignInRequested();case LineSignInRequested() when lineSignInRequested != null:
return lineSignInRequested();case LogoutRequested() when logoutRequested != null:
return logoutRequested();case AuthCheckRequested() when authCheckRequested != null:
return authCheckRequested();case _:
  return null;

}
}

}

/// @nodoc


class GoogleSignInRequested implements AuthEvent {
  const GoogleSignInRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleSignInRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.googleSignInRequested()';
}


}




/// @nodoc


class AppleSignInRequested implements AuthEvent {
  const AppleSignInRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppleSignInRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.appleSignInRequested()';
}


}




/// @nodoc


class LineSignInRequested implements AuthEvent {
  const LineSignInRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineSignInRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.lineSignInRequested()';
}


}




/// @nodoc


class LogoutRequested implements AuthEvent {
  const LogoutRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogoutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logoutRequested()';
}


}




/// @nodoc


class AuthCheckRequested implements AuthEvent {
  const AuthCheckRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCheckRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.authCheckRequested()';
}


}




// dart format on
