// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseModel {

 int? get id; String? get syncId; String get currencyCode; String get title; int get amountMinor;@JsonKey(name: 'amount') double? get legacyAmount; String get date; String get categoryId; int? get category;@JsonKey(includeFromJson: false, includeToJson: false) CategoryModel? get categoryDetails; int get isIncome;
/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseModelCopyWith<ExpenseModel> get copyWith => _$ExpenseModelCopyWithImpl<ExpenseModel>(this as ExpenseModel, _$identity);

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExpenseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.syncId, _this.syncId) || other.syncId == _this.syncId)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.legacyAmount, _this.legacyAmount) || other.legacyAmount == _this.legacyAmount)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.categoryDetails, _this.categoryDetails) || other.categoryDetails == _this.categoryDetails)&&(identical(other.isIncome, _this.isIncome) || other.isIncome == _this.isIncome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExpenseModel;
  return Object.hash(runtimeType,_this.id,_this.syncId,_this.currencyCode,_this.title,_this.amountMinor,_this.legacyAmount,_this.date,_this.categoryId,_this.category,_this.categoryDetails,_this.isIncome);
}

@override
String toString() {
  final _this = this as ExpenseModel;
  return 'ExpenseModel(id: ${_this.id}, syncId: ${_this.syncId}, currencyCode: ${_this.currencyCode}, title: ${_this.title}, amountMinor: ${_this.amountMinor}, legacyAmount: ${_this.legacyAmount}, date: ${_this.date}, categoryId: ${_this.categoryId}, category: ${_this.category}, categoryDetails: ${_this.categoryDetails}, isIncome: ${_this.isIncome})';
}


}

/// @nodoc
abstract mixin class $ExpenseModelCopyWith<$Res>  {
  factory $ExpenseModelCopyWith(ExpenseModel value, $Res Function(ExpenseModel) _then) = _$ExpenseModelCopyWithImpl;
@useResult
$Res call({
 int? id, String? syncId, String currencyCode, String title, int amountMinor,@JsonKey(name: 'amount') double? legacyAmount, String date, String categoryId, int? category,@JsonKey(includeFromJson: false, includeToJson: false) CategoryModel? categoryDetails, int isIncome
});


$CategoryModelCopyWith<$Res>? get categoryDetails;

}
/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._self, this._then);

  final ExpenseModel _self;
  final $Res Function(ExpenseModel) _then;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? syncId = freezed,Object? currencyCode = null,Object? title = null,Object? amountMinor = null,Object? legacyAmount = freezed,Object? date = null,Object? categoryId = null,Object? category = freezed,Object? categoryDetails = freezed,Object? isIncome = null,}) {
  return _then(ExpenseModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,syncId: freezed == syncId ? _self.syncId : syncId // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,legacyAmount: freezed == legacyAmount ? _self.legacyAmount : legacyAmount // ignore: cast_nullable_to_non_nullable
as double?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as int?,categoryDetails: freezed == categoryDetails ? _self.categoryDetails : categoryDetails // ignore: cast_nullable_to_non_nullable
as CategoryModel?,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get categoryDetails {
    if (_self.categoryDetails == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.categoryDetails!, (value) {
    return _then(_self.copyWith(categoryDetails: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExpenseModel].
extension ExpenseModelPatterns on ExpenseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? syncId,  String currencyCode,  String title,  int amountMinor, @JsonKey(name: 'amount')  double? legacyAmount,  String date,  String categoryId,  int? category, @JsonKey(includeFromJson: false, includeToJson: false)  CategoryModel? categoryDetails,  int isIncome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
return $default(_that.id,_that.syncId,_that.currencyCode,_that.title,_that.amountMinor,_that.legacyAmount,_that.date,_that.categoryId,_that.category,_that.categoryDetails,_that.isIncome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? syncId,  String currencyCode,  String title,  int amountMinor, @JsonKey(name: 'amount')  double? legacyAmount,  String date,  String categoryId,  int? category, @JsonKey(includeFromJson: false, includeToJson: false)  CategoryModel? categoryDetails,  int isIncome)  $default,) {final _that = this;
switch (_that) {
case _ExpenseModel():
return $default(_that.id,_that.syncId,_that.currencyCode,_that.title,_that.amountMinor,_that.legacyAmount,_that.date,_that.categoryId,_that.category,_that.categoryDetails,_that.isIncome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? syncId,  String currencyCode,  String title,  int amountMinor, @JsonKey(name: 'amount')  double? legacyAmount,  String date,  String categoryId,  int? category, @JsonKey(includeFromJson: false, includeToJson: false)  CategoryModel? categoryDetails,  int isIncome)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
return $default(_that.id,_that.syncId,_that.currencyCode,_that.title,_that.amountMinor,_that.legacyAmount,_that.date,_that.categoryId,_that.category,_that.categoryDetails,_that.isIncome);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseModel implements ExpenseModel {
  const _ExpenseModel({this.id, this.syncId, this.currencyCode = 'USD', required this.title, required this.amountMinor, @JsonKey(name: 'amount') this.legacyAmount, required this.date, required this.categoryId, this.category, @JsonKey(includeFromJson: false, includeToJson: false) this.categoryDetails, required this.isIncome});
  factory _ExpenseModel.fromJson(Map<String, dynamic> json) => _$ExpenseModelFromJson(json);

@override final  int? id;
@override final  String? syncId;
@override@JsonKey() final  String currencyCode;
@override final  String title;
@override final  int amountMinor;
@override@JsonKey(name: 'amount') final  double? legacyAmount;
@override final  String date;
@override final  String categoryId;
@override final  int? category;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  CategoryModel? categoryDetails;
@override final  int isIncome;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseModelCopyWith<_ExpenseModel> get copyWith => __$ExpenseModelCopyWithImpl<_ExpenseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.syncId, syncId) || other.syncId == syncId)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.legacyAmount, legacyAmount) || other.legacyAmount == legacyAmount)&&(identical(other.date, date) || other.date == date)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.category, category) || other.category == category)&&(identical(other.categoryDetails, categoryDetails) || other.categoryDetails == categoryDetails)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,syncId,currencyCode,title,amountMinor,legacyAmount,date,categoryId,category,categoryDetails,isIncome);
}

@override
String toString() {
    return 'ExpenseModel(id: $id, syncId: $syncId, currencyCode: $currencyCode, title: $title, amountMinor: $amountMinor, legacyAmount: $legacyAmount, date: $date, categoryId: $categoryId, category: $category, categoryDetails: $categoryDetails, isIncome: $isIncome)';
}


}

/// @nodoc
abstract mixin class _$ExpenseModelCopyWith<$Res> implements $ExpenseModelCopyWith<$Res> {
  factory _$ExpenseModelCopyWith(_ExpenseModel value, $Res Function(_ExpenseModel) _then) = __$ExpenseModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? syncId, String currencyCode, String title, int amountMinor,@JsonKey(name: 'amount') double? legacyAmount, String date, String categoryId, int? category,@JsonKey(includeFromJson: false, includeToJson: false) CategoryModel? categoryDetails, int isIncome
});


@override $CategoryModelCopyWith<$Res>? get categoryDetails;

}
/// @nodoc
class __$ExpenseModelCopyWithImpl<$Res>
    implements _$ExpenseModelCopyWith<$Res> {
  __$ExpenseModelCopyWithImpl(this._self, this._then);

  final _ExpenseModel _self;
  final $Res Function(_ExpenseModel) _then;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? syncId = freezed,Object? currencyCode = null,Object? title = null,Object? amountMinor = null,Object? legacyAmount = freezed,Object? date = null,Object? categoryId = null,Object? category = freezed,Object? categoryDetails = freezed,Object? isIncome = null,}) {
  return _then(_ExpenseModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,syncId: freezed == syncId ? _self.syncId : syncId // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,legacyAmount: freezed == legacyAmount ? _self.legacyAmount : legacyAmount // ignore: cast_nullable_to_non_nullable
as double?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as int?,categoryDetails: freezed == categoryDetails ? _self.categoryDetails : categoryDetails // ignore: cast_nullable_to_non_nullable
as CategoryModel?,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get categoryDetails {
    if (_self.categoryDetails == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.categoryDetails!, (value) {
    return _then(_self.copyWith(categoryDetails: value));
  });
}
}

// dart format on
