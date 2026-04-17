// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent()';
}


}

/// @nodoc
class $FeedEventCopyWith<$Res>  {
$FeedEventCopyWith(FeedEvent _, $Res Function(FeedEvent) __);
}


/// Adds pattern-matching-related methods to [FeedEvent].
extension FeedEventPatterns on FeedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FetchFeedRequested value)?  fetchFeedRequested,TResult Function( FetchMoreFeedRequested value)?  fetchMoreFeedRequested,TResult Function( ToggleLikeRequested value)?  toggleLikeRequested,TResult Function( ViewAdded value)?  viewAdded,TResult Function( UploadVideoRequested value)?  uploadVideoRequested,TResult Function( Reset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FetchFeedRequested() when fetchFeedRequested != null:
return fetchFeedRequested(_that);case FetchMoreFeedRequested() when fetchMoreFeedRequested != null:
return fetchMoreFeedRequested(_that);case ToggleLikeRequested() when toggleLikeRequested != null:
return toggleLikeRequested(_that);case ViewAdded() when viewAdded != null:
return viewAdded(_that);case UploadVideoRequested() when uploadVideoRequested != null:
return uploadVideoRequested(_that);case Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FetchFeedRequested value)  fetchFeedRequested,required TResult Function( FetchMoreFeedRequested value)  fetchMoreFeedRequested,required TResult Function( ToggleLikeRequested value)  toggleLikeRequested,required TResult Function( ViewAdded value)  viewAdded,required TResult Function( UploadVideoRequested value)  uploadVideoRequested,required TResult Function( Reset value)  reset,}){
final _that = this;
switch (_that) {
case FetchFeedRequested():
return fetchFeedRequested(_that);case FetchMoreFeedRequested():
return fetchMoreFeedRequested(_that);case ToggleLikeRequested():
return toggleLikeRequested(_that);case ViewAdded():
return viewAdded(_that);case UploadVideoRequested():
return uploadVideoRequested(_that);case Reset():
return reset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FetchFeedRequested value)?  fetchFeedRequested,TResult? Function( FetchMoreFeedRequested value)?  fetchMoreFeedRequested,TResult? Function( ToggleLikeRequested value)?  toggleLikeRequested,TResult? Function( ViewAdded value)?  viewAdded,TResult? Function( UploadVideoRequested value)?  uploadVideoRequested,TResult? Function( Reset value)?  reset,}){
final _that = this;
switch (_that) {
case FetchFeedRequested() when fetchFeedRequested != null:
return fetchFeedRequested(_that);case FetchMoreFeedRequested() when fetchMoreFeedRequested != null:
return fetchMoreFeedRequested(_that);case ToggleLikeRequested() when toggleLikeRequested != null:
return toggleLikeRequested(_that);case ViewAdded() when viewAdded != null:
return viewAdded(_that);case UploadVideoRequested() when uploadVideoRequested != null:
return uploadVideoRequested(_that);case Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetchFeedRequested,TResult Function()?  fetchMoreFeedRequested,TResult Function( String videoId)?  toggleLikeRequested,TResult Function( String videoId)?  viewAdded,TResult Function( String filePath)?  uploadVideoRequested,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FetchFeedRequested() when fetchFeedRequested != null:
return fetchFeedRequested();case FetchMoreFeedRequested() when fetchMoreFeedRequested != null:
return fetchMoreFeedRequested();case ToggleLikeRequested() when toggleLikeRequested != null:
return toggleLikeRequested(_that.videoId);case ViewAdded() when viewAdded != null:
return viewAdded(_that.videoId);case UploadVideoRequested() when uploadVideoRequested != null:
return uploadVideoRequested(_that.filePath);case Reset() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetchFeedRequested,required TResult Function()  fetchMoreFeedRequested,required TResult Function( String videoId)  toggleLikeRequested,required TResult Function( String videoId)  viewAdded,required TResult Function( String filePath)  uploadVideoRequested,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case FetchFeedRequested():
return fetchFeedRequested();case FetchMoreFeedRequested():
return fetchMoreFeedRequested();case ToggleLikeRequested():
return toggleLikeRequested(_that.videoId);case ViewAdded():
return viewAdded(_that.videoId);case UploadVideoRequested():
return uploadVideoRequested(_that.filePath);case Reset():
return reset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetchFeedRequested,TResult? Function()?  fetchMoreFeedRequested,TResult? Function( String videoId)?  toggleLikeRequested,TResult? Function( String videoId)?  viewAdded,TResult? Function( String filePath)?  uploadVideoRequested,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case FetchFeedRequested() when fetchFeedRequested != null:
return fetchFeedRequested();case FetchMoreFeedRequested() when fetchMoreFeedRequested != null:
return fetchMoreFeedRequested();case ToggleLikeRequested() when toggleLikeRequested != null:
return toggleLikeRequested(_that.videoId);case ViewAdded() when viewAdded != null:
return viewAdded(_that.videoId);case UploadVideoRequested() when uploadVideoRequested != null:
return uploadVideoRequested(_that.filePath);case Reset() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class FetchFeedRequested implements FeedEvent {
  const FetchFeedRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchFeedRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.fetchFeedRequested()';
}


}




/// @nodoc


class FetchMoreFeedRequested implements FeedEvent {
  const FetchMoreFeedRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchMoreFeedRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.fetchMoreFeedRequested()';
}


}




/// @nodoc


class ToggleLikeRequested implements FeedEvent {
  const ToggleLikeRequested(this.videoId);
  

 final  String videoId;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleLikeRequestedCopyWith<ToggleLikeRequested> get copyWith => _$ToggleLikeRequestedCopyWithImpl<ToggleLikeRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleLikeRequested&&(identical(other.videoId, videoId) || other.videoId == videoId));
}


@override
int get hashCode => Object.hash(runtimeType,videoId);

@override
String toString() {
  return 'FeedEvent.toggleLikeRequested(videoId: $videoId)';
}


}

/// @nodoc
abstract mixin class $ToggleLikeRequestedCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $ToggleLikeRequestedCopyWith(ToggleLikeRequested value, $Res Function(ToggleLikeRequested) _then) = _$ToggleLikeRequestedCopyWithImpl;
@useResult
$Res call({
 String videoId
});




}
/// @nodoc
class _$ToggleLikeRequestedCopyWithImpl<$Res>
    implements $ToggleLikeRequestedCopyWith<$Res> {
  _$ToggleLikeRequestedCopyWithImpl(this._self, this._then);

  final ToggleLikeRequested _self;
  final $Res Function(ToggleLikeRequested) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? videoId = null,}) {
  return _then(ToggleLikeRequested(
null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ViewAdded implements FeedEvent {
  const ViewAdded(this.videoId);
  

 final  String videoId;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewAddedCopyWith<ViewAdded> get copyWith => _$ViewAddedCopyWithImpl<ViewAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewAdded&&(identical(other.videoId, videoId) || other.videoId == videoId));
}


@override
int get hashCode => Object.hash(runtimeType,videoId);

@override
String toString() {
  return 'FeedEvent.viewAdded(videoId: $videoId)';
}


}

/// @nodoc
abstract mixin class $ViewAddedCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $ViewAddedCopyWith(ViewAdded value, $Res Function(ViewAdded) _then) = _$ViewAddedCopyWithImpl;
@useResult
$Res call({
 String videoId
});




}
/// @nodoc
class _$ViewAddedCopyWithImpl<$Res>
    implements $ViewAddedCopyWith<$Res> {
  _$ViewAddedCopyWithImpl(this._self, this._then);

  final ViewAdded _self;
  final $Res Function(ViewAdded) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? videoId = null,}) {
  return _then(ViewAdded(
null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UploadVideoRequested implements FeedEvent {
  const UploadVideoRequested(this.filePath);
  

 final  String filePath;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadVideoRequestedCopyWith<UploadVideoRequested> get copyWith => _$UploadVideoRequestedCopyWithImpl<UploadVideoRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadVideoRequested&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode => Object.hash(runtimeType,filePath);

@override
String toString() {
  return 'FeedEvent.uploadVideoRequested(filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class $UploadVideoRequestedCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $UploadVideoRequestedCopyWith(UploadVideoRequested value, $Res Function(UploadVideoRequested) _then) = _$UploadVideoRequestedCopyWithImpl;
@useResult
$Res call({
 String filePath
});




}
/// @nodoc
class _$UploadVideoRequestedCopyWithImpl<$Res>
    implements $UploadVideoRequestedCopyWith<$Res> {
  _$UploadVideoRequestedCopyWithImpl(this._self, this._then);

  final UploadVideoRequested _self;
  final $Res Function(UploadVideoRequested) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filePath = null,}) {
  return _then(UploadVideoRequested(
null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class Reset implements FeedEvent {
  const Reset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.reset()';
}


}




// dart format on
