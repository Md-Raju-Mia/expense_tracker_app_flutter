// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostModel {

@JsonKey(fromJson: _nonNegativeInt) int get id;@JsonKey(fromJson: _nonNegativeInt) int get userId; String get title; String get body; List<String> get tags; ReactionsModel get reactions;@JsonKey(fromJson: _nonNegativeInt) int get views;
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostModelCopyWith<PostModel> get copyWith => _$PostModelCopyWithImpl<PostModel>(this as PostModel, _$identity);

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.reactions, _this.reactions) || other.reactions == _this.reactions)&&(identical(other.views, _this.views) || other.views == _this.views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostModel;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.title,_this.body,const DeepCollectionEquality().hash(_this.tags),_this.reactions,_this.views);
}

@override
String toString() {
  final _this = this as PostModel;
  return 'PostModel(id: ${_this.id}, userId: ${_this.userId}, title: ${_this.title}, body: ${_this.body}, tags: ${_this.tags}, reactions: ${_this.reactions}, views: ${_this.views})';
}


}

/// @nodoc
abstract mixin class $PostModelCopyWith<$Res>  {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) _then) = _$PostModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _nonNegativeInt) int id,@JsonKey(fromJson: _nonNegativeInt) int userId, String title, String body, List<String> tags, ReactionsModel reactions,@JsonKey(fromJson: _nonNegativeInt) int views
});


$ReactionsModelCopyWith<$Res> get reactions;

}
/// @nodoc
class _$PostModelCopyWithImpl<$Res>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._self, this._then);

  final PostModel _self;
  final $Res Function(PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? body = null,Object? tags = null,Object? reactions = null,Object? views = null,}) {
  return _then(PostModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as ReactionsModel,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReactionsModelCopyWith<$Res> get reactions {
  
  return $ReactionsModelCopyWith<$Res>(_self.reactions, (value) {
    return _then(_self.copyWith(reactions: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostModel].
extension PostModelPatterns on PostModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostModel value)  $default,){
final _that = this;
switch (_that) {
case _PostModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _nonNegativeInt)  int id, @JsonKey(fromJson: _nonNegativeInt)  int userId,  String title,  String body,  List<String> tags,  ReactionsModel reactions, @JsonKey(fromJson: _nonNegativeInt)  int views)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.body,_that.tags,_that.reactions,_that.views);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _nonNegativeInt)  int id, @JsonKey(fromJson: _nonNegativeInt)  int userId,  String title,  String body,  List<String> tags,  ReactionsModel reactions, @JsonKey(fromJson: _nonNegativeInt)  int views)  $default,) {final _that = this;
switch (_that) {
case _PostModel():
return $default(_that.id,_that.userId,_that.title,_that.body,_that.tags,_that.reactions,_that.views);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _nonNegativeInt)  int id, @JsonKey(fromJson: _nonNegativeInt)  int userId,  String title,  String body,  List<String> tags,  ReactionsModel reactions, @JsonKey(fromJson: _nonNegativeInt)  int views)?  $default,) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.body,_that.tags,_that.reactions,_that.views);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostModel implements PostModel {
  const _PostModel({@JsonKey(fromJson: _nonNegativeInt) required this.id, @JsonKey(fromJson: _nonNegativeInt) required this.userId, required this.title, required this.body, required  List<String> tags, required this.reactions, @JsonKey(fromJson: _nonNegativeInt) required this.views}): _tags = tags;
  factory _PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

@override@JsonKey(fromJson: _nonNegativeInt) final  int id;
@override@JsonKey(fromJson: _nonNegativeInt) final  int userId;
@override final  String title;
@override final  String body;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  ReactionsModel reactions;
@override@JsonKey(fromJson: _nonNegativeInt) final  int views;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostModelCopyWith<_PostModel> get copyWith => __$PostModelCopyWithImpl<_PostModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.reactions, reactions) || other.reactions == reactions)&&(identical(other.views, views) || other.views == views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,title,body,const DeepCollectionEquality().hash(_tags),reactions,views);
}

@override
String toString() {
    return 'PostModel(id: $id, userId: $userId, title: $title, body: $body, tags: $tags, reactions: $reactions, views: $views)';
}


}

/// @nodoc
abstract mixin class _$PostModelCopyWith<$Res> implements $PostModelCopyWith<$Res> {
  factory _$PostModelCopyWith(_PostModel value, $Res Function(_PostModel) _then) = __$PostModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _nonNegativeInt) int id,@JsonKey(fromJson: _nonNegativeInt) int userId, String title, String body, List<String> tags, ReactionsModel reactions,@JsonKey(fromJson: _nonNegativeInt) int views
});


@override $ReactionsModelCopyWith<$Res> get reactions;

}
/// @nodoc
class __$PostModelCopyWithImpl<$Res>
    implements _$PostModelCopyWith<$Res> {
  __$PostModelCopyWithImpl(this._self, this._then);

  final _PostModel _self;
  final $Res Function(_PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? body = null,Object? tags = null,Object? reactions = null,Object? views = null,}) {
  return _then(_PostModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as ReactionsModel,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReactionsModelCopyWith<$Res> get reactions {
  
  return $ReactionsModelCopyWith<$Res>(_self.reactions, (value) {
    return _then(_self.copyWith(reactions: value));
  });
}
}


/// @nodoc
mixin _$ReactionsModel {

@JsonKey(fromJson: _nonNegativeInt) int get likes;@JsonKey(fromJson: _nonNegativeInt) int get dislikes;
/// Create a copy of ReactionsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReactionsModelCopyWith<ReactionsModel> get copyWith => _$ReactionsModelCopyWithImpl<ReactionsModel>(this as ReactionsModel, _$identity);

  /// Serializes this ReactionsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReactionsModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReactionsModel&&(identical(other.likes, _this.likes) || other.likes == _this.likes)&&(identical(other.dislikes, _this.dislikes) || other.dislikes == _this.dislikes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReactionsModel;
  return Object.hash(runtimeType,_this.likes,_this.dislikes);
}

@override
String toString() {
  final _this = this as ReactionsModel;
  return 'ReactionsModel(likes: ${_this.likes}, dislikes: ${_this.dislikes})';
}


}

/// @nodoc
abstract mixin class $ReactionsModelCopyWith<$Res>  {
  factory $ReactionsModelCopyWith(ReactionsModel value, $Res Function(ReactionsModel) _then) = _$ReactionsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _nonNegativeInt) int likes,@JsonKey(fromJson: _nonNegativeInt) int dislikes
});




}
/// @nodoc
class _$ReactionsModelCopyWithImpl<$Res>
    implements $ReactionsModelCopyWith<$Res> {
  _$ReactionsModelCopyWithImpl(this._self, this._then);

  final ReactionsModel _self;
  final $Res Function(ReactionsModel) _then;

/// Create a copy of ReactionsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likes = null,Object? dislikes = null,}) {
  return _then(ReactionsModel(
likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,dislikes: null == dislikes ? _self.dislikes : dislikes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReactionsModel].
extension ReactionsModelPatterns on ReactionsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReactionsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReactionsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReactionsModel value)  $default,){
final _that = this;
switch (_that) {
case _ReactionsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReactionsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReactionsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _nonNegativeInt)  int likes, @JsonKey(fromJson: _nonNegativeInt)  int dislikes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReactionsModel() when $default != null:
return $default(_that.likes,_that.dislikes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _nonNegativeInt)  int likes, @JsonKey(fromJson: _nonNegativeInt)  int dislikes)  $default,) {final _that = this;
switch (_that) {
case _ReactionsModel():
return $default(_that.likes,_that.dislikes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _nonNegativeInt)  int likes, @JsonKey(fromJson: _nonNegativeInt)  int dislikes)?  $default,) {final _that = this;
switch (_that) {
case _ReactionsModel() when $default != null:
return $default(_that.likes,_that.dislikes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReactionsModel implements ReactionsModel {
  const _ReactionsModel({@JsonKey(fromJson: _nonNegativeInt) required this.likes, @JsonKey(fromJson: _nonNegativeInt) required this.dislikes});
  factory _ReactionsModel.fromJson(Map<String, dynamic> json) => _$ReactionsModelFromJson(json);

@override@JsonKey(fromJson: _nonNegativeInt) final  int likes;
@override@JsonKey(fromJson: _nonNegativeInt) final  int dislikes;

/// Create a copy of ReactionsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReactionsModelCopyWith<_ReactionsModel> get copyWith => __$ReactionsModelCopyWithImpl<_ReactionsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReactionsModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReactionsModel&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.dislikes, dislikes) || other.dislikes == dislikes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,likes,dislikes);
}

@override
String toString() {
    return 'ReactionsModel(likes: $likes, dislikes: $dislikes)';
}


}

/// @nodoc
abstract mixin class _$ReactionsModelCopyWith<$Res> implements $ReactionsModelCopyWith<$Res> {
  factory _$ReactionsModelCopyWith(_ReactionsModel value, $Res Function(_ReactionsModel) _then) = __$ReactionsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _nonNegativeInt) int likes,@JsonKey(fromJson: _nonNegativeInt) int dislikes
});




}
/// @nodoc
class __$ReactionsModelCopyWithImpl<$Res>
    implements _$ReactionsModelCopyWith<$Res> {
  __$ReactionsModelCopyWithImpl(this._self, this._then);

  final _ReactionsModel _self;
  final $Res Function(_ReactionsModel) _then;

/// Create a copy of ReactionsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likes = null,Object? dislikes = null,}) {
  return _then(_ReactionsModel(
likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,dislikes: null == dislikes ? _self.dislikes : dislikes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FeedResponseModel {

 List<PostModel> get posts;@JsonKey(fromJson: _nonNegativeInt) int get total;@JsonKey(fromJson: _nonNegativeInt) int get skip;@JsonKey(fromJson: _nonNegativeInt) int get limit;
/// Create a copy of FeedResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedResponseModelCopyWith<FeedResponseModel> get copyWith => _$FeedResponseModelCopyWithImpl<FeedResponseModel>(this as FeedResponseModel, _$identity);

  /// Serializes this FeedResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedResponseModel&&const DeepCollectionEquality().equals(other.posts, _this.posts)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.skip, _this.skip) || other.skip == _this.skip)&&(identical(other.limit, _this.limit) || other.limit == _this.limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedResponseModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.posts),_this.total,_this.skip,_this.limit);
}

@override
String toString() {
  final _this = this as FeedResponseModel;
  return 'FeedResponseModel(posts: ${_this.posts}, total: ${_this.total}, skip: ${_this.skip}, limit: ${_this.limit})';
}


}

/// @nodoc
abstract mixin class $FeedResponseModelCopyWith<$Res>  {
  factory $FeedResponseModelCopyWith(FeedResponseModel value, $Res Function(FeedResponseModel) _then) = _$FeedResponseModelCopyWithImpl;
@useResult
$Res call({
 List<PostModel> posts,@JsonKey(fromJson: _nonNegativeInt) int total,@JsonKey(fromJson: _nonNegativeInt) int skip,@JsonKey(fromJson: _nonNegativeInt) int limit
});




}
/// @nodoc
class _$FeedResponseModelCopyWithImpl<$Res>
    implements $FeedResponseModelCopyWith<$Res> {
  _$FeedResponseModelCopyWithImpl(this._self, this._then);

  final FeedResponseModel _self;
  final $Res Function(FeedResponseModel) _then;

/// Create a copy of FeedResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? total = null,Object? skip = null,Object? limit = null,}) {
  return _then(FeedResponseModel(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<PostModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedResponseModel].
extension FeedResponseModelPatterns on FeedResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _FeedResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _FeedResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PostModel> posts, @JsonKey(fromJson: _nonNegativeInt)  int total, @JsonKey(fromJson: _nonNegativeInt)  int skip, @JsonKey(fromJson: _nonNegativeInt)  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedResponseModel() when $default != null:
return $default(_that.posts,_that.total,_that.skip,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PostModel> posts, @JsonKey(fromJson: _nonNegativeInt)  int total, @JsonKey(fromJson: _nonNegativeInt)  int skip, @JsonKey(fromJson: _nonNegativeInt)  int limit)  $default,) {final _that = this;
switch (_that) {
case _FeedResponseModel():
return $default(_that.posts,_that.total,_that.skip,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PostModel> posts, @JsonKey(fromJson: _nonNegativeInt)  int total, @JsonKey(fromJson: _nonNegativeInt)  int skip, @JsonKey(fromJson: _nonNegativeInt)  int limit)?  $default,) {final _that = this;
switch (_that) {
case _FeedResponseModel() when $default != null:
return $default(_that.posts,_that.total,_that.skip,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedResponseModel implements FeedResponseModel {
  const _FeedResponseModel({required  List<PostModel> posts, @JsonKey(fromJson: _nonNegativeInt) required this.total, @JsonKey(fromJson: _nonNegativeInt) required this.skip, @JsonKey(fromJson: _nonNegativeInt) required this.limit}): _posts = posts;
  factory _FeedResponseModel.fromJson(Map<String, dynamic> json) => _$FeedResponseModelFromJson(json);

 final  List<PostModel> _posts;
@override List<PostModel> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override@JsonKey(fromJson: _nonNegativeInt) final  int total;
@override@JsonKey(fromJson: _nonNegativeInt) final  int skip;
@override@JsonKey(fromJson: _nonNegativeInt) final  int limit;

/// Create a copy of FeedResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedResponseModelCopyWith<_FeedResponseModel> get copyWith => __$FeedResponseModelCopyWithImpl<_FeedResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedResponseModel&&const DeepCollectionEquality().equals(other.posts, _posts)&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),total,skip,limit);
}

@override
String toString() {
    return 'FeedResponseModel(posts: $posts, total: $total, skip: $skip, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$FeedResponseModelCopyWith<$Res> implements $FeedResponseModelCopyWith<$Res> {
  factory _$FeedResponseModelCopyWith(_FeedResponseModel value, $Res Function(_FeedResponseModel) _then) = __$FeedResponseModelCopyWithImpl;
@override @useResult
$Res call({
 List<PostModel> posts,@JsonKey(fromJson: _nonNegativeInt) int total,@JsonKey(fromJson: _nonNegativeInt) int skip,@JsonKey(fromJson: _nonNegativeInt) int limit
});




}
/// @nodoc
class __$FeedResponseModelCopyWithImpl<$Res>
    implements _$FeedResponseModelCopyWith<$Res> {
  __$FeedResponseModelCopyWithImpl(this._self, this._then);

  final _FeedResponseModel _self;
  final $Res Function(_FeedResponseModel) _then;

/// Create a copy of FeedResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? total = null,Object? skip = null,Object? limit = null,}) {
  return _then(_FeedResponseModel(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<PostModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PostCommentModel {

@JsonKey(fromJson: _nonNegativeInt) int get id; String get body; PostCommentUserModel get user;@JsonKey(fromJson: _nonNegativeInt) int get likes;
/// Create a copy of PostCommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCommentModelCopyWith<PostCommentModel> get copyWith => _$PostCommentModelCopyWithImpl<PostCommentModel>(this as PostCommentModel, _$identity);

  /// Serializes this PostCommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostCommentModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostCommentModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.likes, _this.likes) || other.likes == _this.likes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostCommentModel;
  return Object.hash(runtimeType,_this.id,_this.body,_this.user,_this.likes);
}

@override
String toString() {
  final _this = this as PostCommentModel;
  return 'PostCommentModel(id: ${_this.id}, body: ${_this.body}, user: ${_this.user}, likes: ${_this.likes})';
}


}

/// @nodoc
abstract mixin class $PostCommentModelCopyWith<$Res>  {
  factory $PostCommentModelCopyWith(PostCommentModel value, $Res Function(PostCommentModel) _then) = _$PostCommentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _nonNegativeInt) int id, String body, PostCommentUserModel user,@JsonKey(fromJson: _nonNegativeInt) int likes
});


$PostCommentUserModelCopyWith<$Res> get user;

}
/// @nodoc
class _$PostCommentModelCopyWithImpl<$Res>
    implements $PostCommentModelCopyWith<$Res> {
  _$PostCommentModelCopyWithImpl(this._self, this._then);

  final PostCommentModel _self;
  final $Res Function(PostCommentModel) _then;

/// Create a copy of PostCommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? body = null,Object? user = null,Object? likes = null,}) {
  return _then(PostCommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as PostCommentUserModel,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PostCommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCommentUserModelCopyWith<$Res> get user {
  
  return $PostCommentUserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostCommentModel].
extension PostCommentModelPatterns on PostCommentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostCommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostCommentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostCommentModel value)  $default,){
final _that = this;
switch (_that) {
case _PostCommentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostCommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostCommentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _nonNegativeInt)  int id,  String body,  PostCommentUserModel user, @JsonKey(fromJson: _nonNegativeInt)  int likes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostCommentModel() when $default != null:
return $default(_that.id,_that.body,_that.user,_that.likes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _nonNegativeInt)  int id,  String body,  PostCommentUserModel user, @JsonKey(fromJson: _nonNegativeInt)  int likes)  $default,) {final _that = this;
switch (_that) {
case _PostCommentModel():
return $default(_that.id,_that.body,_that.user,_that.likes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _nonNegativeInt)  int id,  String body,  PostCommentUserModel user, @JsonKey(fromJson: _nonNegativeInt)  int likes)?  $default,) {final _that = this;
switch (_that) {
case _PostCommentModel() when $default != null:
return $default(_that.id,_that.body,_that.user,_that.likes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostCommentModel implements PostCommentModel {
  const _PostCommentModel({@JsonKey(fromJson: _nonNegativeInt) required this.id, required this.body, required this.user, @JsonKey(fromJson: _nonNegativeInt) required this.likes});
  factory _PostCommentModel.fromJson(Map<String, dynamic> json) => _$PostCommentModelFromJson(json);

@override@JsonKey(fromJson: _nonNegativeInt) final  int id;
@override final  String body;
@override final  PostCommentUserModel user;
@override@JsonKey(fromJson: _nonNegativeInt) final  int likes;

/// Create a copy of PostCommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCommentModelCopyWith<_PostCommentModel> get copyWith => __$PostCommentModelCopyWithImpl<_PostCommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostCommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostCommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.user, user) || other.user == user)&&(identical(other.likes, likes) || other.likes == likes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,body,user,likes);
}

@override
String toString() {
    return 'PostCommentModel(id: $id, body: $body, user: $user, likes: $likes)';
}


}

/// @nodoc
abstract mixin class _$PostCommentModelCopyWith<$Res> implements $PostCommentModelCopyWith<$Res> {
  factory _$PostCommentModelCopyWith(_PostCommentModel value, $Res Function(_PostCommentModel) _then) = __$PostCommentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _nonNegativeInt) int id, String body, PostCommentUserModel user,@JsonKey(fromJson: _nonNegativeInt) int likes
});


@override $PostCommentUserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$PostCommentModelCopyWithImpl<$Res>
    implements _$PostCommentModelCopyWith<$Res> {
  __$PostCommentModelCopyWithImpl(this._self, this._then);

  final _PostCommentModel _self;
  final $Res Function(_PostCommentModel) _then;

/// Create a copy of PostCommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? body = null,Object? user = null,Object? likes = null,}) {
  return _then(_PostCommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as PostCommentUserModel,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PostCommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCommentUserModelCopyWith<$Res> get user {
  
  return $PostCommentUserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$PostCommentUserModel {

 String get fullName;
/// Create a copy of PostCommentUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCommentUserModelCopyWith<PostCommentUserModel> get copyWith => _$PostCommentUserModelCopyWithImpl<PostCommentUserModel>(this as PostCommentUserModel, _$identity);

  /// Serializes this PostCommentUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostCommentUserModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostCommentUserModel&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostCommentUserModel;
  return Object.hash(runtimeType,_this.fullName);
}

@override
String toString() {
  final _this = this as PostCommentUserModel;
  return 'PostCommentUserModel(fullName: ${_this.fullName})';
}


}

/// @nodoc
abstract mixin class $PostCommentUserModelCopyWith<$Res>  {
  factory $PostCommentUserModelCopyWith(PostCommentUserModel value, $Res Function(PostCommentUserModel) _then) = _$PostCommentUserModelCopyWithImpl;
@useResult
$Res call({
 String fullName
});




}
/// @nodoc
class _$PostCommentUserModelCopyWithImpl<$Res>
    implements $PostCommentUserModelCopyWith<$Res> {
  _$PostCommentUserModelCopyWithImpl(this._self, this._then);

  final PostCommentUserModel _self;
  final $Res Function(PostCommentUserModel) _then;

/// Create a copy of PostCommentUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,}) {
  return _then(PostCommentUserModel(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostCommentUserModel].
extension PostCommentUserModelPatterns on PostCommentUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostCommentUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostCommentUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostCommentUserModel value)  $default,){
final _that = this;
switch (_that) {
case _PostCommentUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostCommentUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostCommentUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostCommentUserModel() when $default != null:
return $default(_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName)  $default,) {final _that = this;
switch (_that) {
case _PostCommentUserModel():
return $default(_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName)?  $default,) {final _that = this;
switch (_that) {
case _PostCommentUserModel() when $default != null:
return $default(_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostCommentUserModel implements PostCommentUserModel {
  const _PostCommentUserModel({required this.fullName});
  factory _PostCommentUserModel.fromJson(Map<String, dynamic> json) => _$PostCommentUserModelFromJson(json);

@override final  String fullName;

/// Create a copy of PostCommentUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCommentUserModelCopyWith<_PostCommentUserModel> get copyWith => __$PostCommentUserModelCopyWithImpl<_PostCommentUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostCommentUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostCommentUserModel&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fullName);
}

@override
String toString() {
    return 'PostCommentUserModel(fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$PostCommentUserModelCopyWith<$Res> implements $PostCommentUserModelCopyWith<$Res> {
  factory _$PostCommentUserModelCopyWith(_PostCommentUserModel value, $Res Function(_PostCommentUserModel) _then) = __$PostCommentUserModelCopyWithImpl;
@override @useResult
$Res call({
 String fullName
});




}
/// @nodoc
class __$PostCommentUserModelCopyWithImpl<$Res>
    implements _$PostCommentUserModelCopyWith<$Res> {
  __$PostCommentUserModelCopyWithImpl(this._self, this._then);

  final _PostCommentUserModel _self;
  final $Res Function(_PostCommentUserModel) _then;

/// Create a copy of PostCommentUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,}) {
  return _then(_PostCommentUserModel(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CommentsResponseModel {

 List<PostCommentModel> get comments;
/// Create a copy of CommentsResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentsResponseModelCopyWith<CommentsResponseModel> get copyWith => _$CommentsResponseModelCopyWithImpl<CommentsResponseModel>(this as CommentsResponseModel, _$identity);

  /// Serializes this CommentsResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CommentsResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentsResponseModel&&const DeepCollectionEquality().equals(other.comments, _this.comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CommentsResponseModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.comments));
}

@override
String toString() {
  final _this = this as CommentsResponseModel;
  return 'CommentsResponseModel(comments: ${_this.comments})';
}


}

/// @nodoc
abstract mixin class $CommentsResponseModelCopyWith<$Res>  {
  factory $CommentsResponseModelCopyWith(CommentsResponseModel value, $Res Function(CommentsResponseModel) _then) = _$CommentsResponseModelCopyWithImpl;
@useResult
$Res call({
 List<PostCommentModel> comments
});




}
/// @nodoc
class _$CommentsResponseModelCopyWithImpl<$Res>
    implements $CommentsResponseModelCopyWith<$Res> {
  _$CommentsResponseModelCopyWithImpl(this._self, this._then);

  final CommentsResponseModel _self;
  final $Res Function(CommentsResponseModel) _then;

/// Create a copy of CommentsResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comments = null,}) {
  return _then(CommentsResponseModel(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<PostCommentModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentsResponseModel].
extension CommentsResponseModelPatterns on CommentsResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentsResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentsResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentsResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _CommentsResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentsResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CommentsResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PostCommentModel> comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentsResponseModel() when $default != null:
return $default(_that.comments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PostCommentModel> comments)  $default,) {final _that = this;
switch (_that) {
case _CommentsResponseModel():
return $default(_that.comments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PostCommentModel> comments)?  $default,) {final _that = this;
switch (_that) {
case _CommentsResponseModel() when $default != null:
return $default(_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentsResponseModel implements CommentsResponseModel {
  const _CommentsResponseModel({required  List<PostCommentModel> comments}): _comments = comments;
  factory _CommentsResponseModel.fromJson(Map<String, dynamic> json) => _$CommentsResponseModelFromJson(json);

 final  List<PostCommentModel> _comments;
@override List<PostCommentModel> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}


/// Create a copy of CommentsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentsResponseModelCopyWith<_CommentsResponseModel> get copyWith => __$CommentsResponseModelCopyWithImpl<_CommentsResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentsResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentsResponseModel&&const DeepCollectionEquality().equals(other.comments, _comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_comments));
}

@override
String toString() {
    return 'CommentsResponseModel(comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$CommentsResponseModelCopyWith<$Res> implements $CommentsResponseModelCopyWith<$Res> {
  factory _$CommentsResponseModelCopyWith(_CommentsResponseModel value, $Res Function(_CommentsResponseModel) _then) = __$CommentsResponseModelCopyWithImpl;
@override @useResult
$Res call({
 List<PostCommentModel> comments
});




}
/// @nodoc
class __$CommentsResponseModelCopyWithImpl<$Res>
    implements _$CommentsResponseModelCopyWith<$Res> {
  __$CommentsResponseModelCopyWithImpl(this._self, this._then);

  final _CommentsResponseModel _self;
  final $Res Function(_CommentsResponseModel) _then;

/// Create a copy of CommentsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comments = null,}) {
  return _then(_CommentsResponseModel(
comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<PostCommentModel>,
  ));
}


}

// dart format on
