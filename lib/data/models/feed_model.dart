import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_model.freezed.dart';
part 'feed_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    @JsonKey(fromJson: _nonNegativeInt) required int id,
    @JsonKey(fromJson: _nonNegativeInt) required int userId,
    required String title,
    required String body,
    required List<String> tags,
    required ReactionsModel reactions,
    @JsonKey(fromJson: _nonNegativeInt) required int views,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

@freezed
abstract class ReactionsModel with _$ReactionsModel {
  const factory ReactionsModel({
    @JsonKey(fromJson: _nonNegativeInt) required int likes,
    @JsonKey(fromJson: _nonNegativeInt) required int dislikes,
  }) = _ReactionsModel;

  factory ReactionsModel.fromJson(Map<String, dynamic> json) =>
      _$ReactionsModelFromJson(json);
}

@freezed
abstract class FeedResponseModel with _$FeedResponseModel {
  const factory FeedResponseModel({
    required List<PostModel> posts,
    @JsonKey(fromJson: _nonNegativeInt) required int total,
    @JsonKey(fromJson: _nonNegativeInt) required int skip,
    @JsonKey(fromJson: _nonNegativeInt) required int limit,
  }) = _FeedResponseModel;

  factory FeedResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseModelFromJson(json);
}

@freezed
abstract class PostCommentModel with _$PostCommentModel {
  const factory PostCommentModel({
    @JsonKey(fromJson: _nonNegativeInt) required int id,
    required String body,
    required PostCommentUserModel user,
    @JsonKey(fromJson: _nonNegativeInt) required int likes,
  }) = _PostCommentModel;

  factory PostCommentModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentModelFromJson(json);
}

@freezed
abstract class PostCommentUserModel with _$PostCommentUserModel {
  const factory PostCommentUserModel({required String fullName}) =
      _PostCommentUserModel;

  factory PostCommentUserModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentUserModelFromJson(json);
}

@freezed
abstract class CommentsResponseModel with _$CommentsResponseModel {
  const factory CommentsResponseModel({
    required List<PostCommentModel> comments,
  }) = _CommentsResponseModel;

  factory CommentsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CommentsResponseModelFromJson(json);
}

int _nonNegativeInt(Object? value) {
  if (value is! int || value < 0) {
    throw FormatException('Expected a non-negative integer, got $value');
  }
  return value;
}
