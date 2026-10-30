// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'posts_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostsRequestModel {

 PostsOperation get operation; int get id; String get query; int get limit; int get skip; String get sortBy; String get order; String get select; String get title; String get body; int get userId;
/// Create a copy of PostsRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostsRequestModelCopyWith<PostsRequestModel> get copyWith => _$PostsRequestModelCopyWithImpl<PostsRequestModel>(this as PostsRequestModel, _$identity);

  /// Serializes this PostsRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostsRequestModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostsRequestModel&&(identical(other.operation, _this.operation) || other.operation == _this.operation)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&(identical(other.skip, _this.skip) || other.skip == _this.skip)&&(identical(other.sortBy, _this.sortBy) || other.sortBy == _this.sortBy)&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.select, _this.select) || other.select == _this.select)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.userId, _this.userId) || other.userId == _this.userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostsRequestModel;
  return Object.hash(runtimeType,_this.operation,_this.id,_this.query,_this.limit,_this.skip,_this.sortBy,_this.order,_this.select,_this.title,_this.body,_this.userId);
}

@override
String toString() {
  final _this = this as PostsRequestModel;
  return 'PostsRequestModel(operation: ${_this.operation}, id: ${_this.id}, query: ${_this.query}, limit: ${_this.limit}, skip: ${_this.skip}, sortBy: ${_this.sortBy}, order: ${_this.order}, select: ${_this.select}, title: ${_this.title}, body: ${_this.body}, userId: ${_this.userId})';
}


}

/// @nodoc
abstract mixin class $PostsRequestModelCopyWith<$Res>  {
  factory $PostsRequestModelCopyWith(PostsRequestModel value, $Res Function(PostsRequestModel) _then) = _$PostsRequestModelCopyWithImpl;
@useResult
$Res call({
 PostsOperation operation, int id, String query, int limit, int skip, String sortBy, String order, String select, String title, String body, int userId
});




}
/// @nodoc
class _$PostsRequestModelCopyWithImpl<$Res>
    implements $PostsRequestModelCopyWith<$Res> {
  _$PostsRequestModelCopyWithImpl(this._self, this._then);

  final PostsRequestModel _self;
  final $Res Function(PostsRequestModel) _then;

/// Create a copy of PostsRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operation = null,Object? id = null,Object? query = null,Object? limit = null,Object? skip = null,Object? sortBy = null,Object? order = null,Object? select = null,Object? title = null,Object? body = null,Object? userId = null,}) {
  return _then(PostsRequestModel(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as PostsOperation,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,select: null == select ? _self.select : select // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PostsRequestModel].
extension PostsRequestModelPatterns on PostsRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostsRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostsRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostsRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _PostsRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostsRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostsRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PostsOperation operation,  int id,  String query,  int limit,  int skip,  String sortBy,  String order,  String select,  String title,  String body,  int userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostsRequestModel() when $default != null:
return $default(_that.operation,_that.id,_that.query,_that.limit,_that.skip,_that.sortBy,_that.order,_that.select,_that.title,_that.body,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PostsOperation operation,  int id,  String query,  int limit,  int skip,  String sortBy,  String order,  String select,  String title,  String body,  int userId)  $default,) {final _that = this;
switch (_that) {
case _PostsRequestModel():
return $default(_that.operation,_that.id,_that.query,_that.limit,_that.skip,_that.sortBy,_that.order,_that.select,_that.title,_that.body,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PostsOperation operation,  int id,  String query,  int limit,  int skip,  String sortBy,  String order,  String select,  String title,  String body,  int userId)?  $default,) {final _that = this;
switch (_that) {
case _PostsRequestModel() when $default != null:
return $default(_that.operation,_that.id,_that.query,_that.limit,_that.skip,_that.sortBy,_that.order,_that.select,_that.title,_that.body,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostsRequestModel extends PostsRequestModel {
  const _PostsRequestModel({required this.operation, required this.id, required this.query, required this.limit, required this.skip, required this.sortBy, required this.order, required this.select, required this.title, required this.body, required this.userId}): super._();
  factory _PostsRequestModel.fromJson(Map<String, dynamic> json) => _$PostsRequestModelFromJson(json);

@override final  PostsOperation operation;
@override final  int id;
@override final  String query;
@override final  int limit;
@override final  int skip;
@override final  String sortBy;
@override final  String order;
@override final  String select;
@override final  String title;
@override final  String body;
@override final  int userId;

/// Create a copy of PostsRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostsRequestModelCopyWith<_PostsRequestModel> get copyWith => __$PostsRequestModelCopyWithImpl<_PostsRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostsRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostsRequestModel&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.id, id) || other.id == id)&&(identical(other.query, query) || other.query == query)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.order, order) || other.order == order)&&(identical(other.select, select) || other.select == select)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,operation,id,query,limit,skip,sortBy,order,select,title,body,userId);
}

@override
String toString() {
    return 'PostsRequestModel(operation: $operation, id: $id, query: $query, limit: $limit, skip: $skip, sortBy: $sortBy, order: $order, select: $select, title: $title, body: $body, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$PostsRequestModelCopyWith<$Res> implements $PostsRequestModelCopyWith<$Res> {
  factory _$PostsRequestModelCopyWith(_PostsRequestModel value, $Res Function(_PostsRequestModel) _then) = __$PostsRequestModelCopyWithImpl;
@override @useResult
$Res call({
 PostsOperation operation, int id, String query, int limit, int skip, String sortBy, String order, String select, String title, String body, int userId
});




}
/// @nodoc
class __$PostsRequestModelCopyWithImpl<$Res>
    implements _$PostsRequestModelCopyWith<$Res> {
  __$PostsRequestModelCopyWithImpl(this._self, this._then);

  final _PostsRequestModel _self;
  final $Res Function(_PostsRequestModel) _then;

/// Create a copy of PostsRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operation = null,Object? id = null,Object? query = null,Object? limit = null,Object? skip = null,Object? sortBy = null,Object? order = null,Object? select = null,Object? title = null,Object? body = null,Object? userId = null,}) {
  return _then(_PostsRequestModel(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as PostsOperation,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,select: null == select ? _self.select : select // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PostsResponseModel {

 Object get data; int get statusCode;
/// Create a copy of PostsResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostsResponseModelCopyWith<PostsResponseModel> get copyWith => _$PostsResponseModelCopyWithImpl<PostsResponseModel>(this as PostsResponseModel, _$identity);

  /// Serializes this PostsResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostsResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostsResponseModel&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.statusCode, _this.statusCode) || other.statusCode == _this.statusCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostsResponseModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.data),_this.statusCode);
}

@override
String toString() {
  final _this = this as PostsResponseModel;
  return 'PostsResponseModel(data: ${_this.data}, statusCode: ${_this.statusCode})';
}


}

/// @nodoc
abstract mixin class $PostsResponseModelCopyWith<$Res>  {
  factory $PostsResponseModelCopyWith(PostsResponseModel value, $Res Function(PostsResponseModel) _then) = _$PostsResponseModelCopyWithImpl;
@useResult
$Res call({
 Object data, int statusCode
});




}
/// @nodoc
class _$PostsResponseModelCopyWithImpl<$Res>
    implements $PostsResponseModelCopyWith<$Res> {
  _$PostsResponseModelCopyWithImpl(this._self, this._then);

  final PostsResponseModel _self;
  final $Res Function(PostsResponseModel) _then;

/// Create a copy of PostsResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? statusCode = null,}) {
  return _then(PostsResponseModel(
data: null == data ? _self.data : data ,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PostsResponseModel].
extension PostsResponseModelPatterns on PostsResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostsResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostsResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostsResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _PostsResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostsResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostsResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Object data,  int statusCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostsResponseModel() when $default != null:
return $default(_that.data,_that.statusCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Object data,  int statusCode)  $default,) {final _that = this;
switch (_that) {
case _PostsResponseModel():
return $default(_that.data,_that.statusCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Object data,  int statusCode)?  $default,) {final _that = this;
switch (_that) {
case _PostsResponseModel() when $default != null:
return $default(_that.data,_that.statusCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostsResponseModel implements PostsResponseModel {
  const _PostsResponseModel({required this.data, required this.statusCode});
  factory _PostsResponseModel.fromJson(Map<String, dynamic> json) => _$PostsResponseModelFromJson(json);

@override final  Object data;
@override final  int statusCode;

/// Create a copy of PostsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostsResponseModelCopyWith<_PostsResponseModel> get copyWith => __$PostsResponseModelCopyWithImpl<_PostsResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostsResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostsResponseModel&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data),statusCode);
}

@override
String toString() {
    return 'PostsResponseModel(data: $data, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class _$PostsResponseModelCopyWith<$Res> implements $PostsResponseModelCopyWith<$Res> {
  factory _$PostsResponseModelCopyWith(_PostsResponseModel value, $Res Function(_PostsResponseModel) _then) = __$PostsResponseModelCopyWithImpl;
@override @useResult
$Res call({
 Object data, int statusCode
});




}
/// @nodoc
class __$PostsResponseModelCopyWithImpl<$Res>
    implements _$PostsResponseModelCopyWith<$Res> {
  __$PostsResponseModelCopyWithImpl(this._self, this._then);

  final _PostsResponseModel _self;
  final $Res Function(_PostsResponseModel) _then;

/// Create a copy of PostsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? statusCode = null,}) {
  return _then(_PostsResponseModel(
data: null == data ? _self.data : data ,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
