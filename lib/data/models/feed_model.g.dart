// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PostModel', json, ($checkedConvert) {
      final val = _PostModel(
        id: $checkedConvert('id', (v) => _nonNegativeInt(v)),
        userId: $checkedConvert('userId', (v) => _nonNegativeInt(v)),
        title: $checkedConvert('title', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        reactions: $checkedConvert(
          'reactions',
          (v) => ReactionsModel.fromJson(v as Map<String, dynamic>),
        ),
        views: $checkedConvert('views', (v) => _nonNegativeInt(v)),
      );
      return val;
    });

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'tags': instance.tags,
      'reactions': instance.reactions.toJson(),
      'views': instance.views,
    };

_ReactionsModel _$ReactionsModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ReactionsModel', json, ($checkedConvert) {
      final val = _ReactionsModel(
        likes: $checkedConvert('likes', (v) => _nonNegativeInt(v)),
        dislikes: $checkedConvert('dislikes', (v) => _nonNegativeInt(v)),
      );
      return val;
    });

Map<String, dynamic> _$ReactionsModelToJson(_ReactionsModel instance) =>
    <String, dynamic>{'likes': instance.likes, 'dislikes': instance.dislikes};

_FeedResponseModel _$FeedResponseModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FeedResponseModel', json, ($checkedConvert) {
      final val = _FeedResponseModel(
        posts: $checkedConvert(
          'posts',
          (v) => (v as List<dynamic>)
              .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        total: $checkedConvert('total', (v) => _nonNegativeInt(v)),
        skip: $checkedConvert('skip', (v) => _nonNegativeInt(v)),
        limit: $checkedConvert('limit', (v) => _nonNegativeInt(v)),
      );
      return val;
    });

Map<String, dynamic> _$FeedResponseModelToJson(_FeedResponseModel instance) =>
    <String, dynamic>{
      'posts': instance.posts.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };

_PostCommentModel _$PostCommentModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PostCommentModel', json, ($checkedConvert) {
      final val = _PostCommentModel(
        id: $checkedConvert('id', (v) => _nonNegativeInt(v)),
        body: $checkedConvert('body', (v) => v as String),
        user: $checkedConvert(
          'user',
          (v) => PostCommentUserModel.fromJson(v as Map<String, dynamic>),
        ),
        likes: $checkedConvert('likes', (v) => _nonNegativeInt(v)),
      );
      return val;
    });

Map<String, dynamic> _$PostCommentModelToJson(_PostCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'user': instance.user.toJson(),
      'likes': instance.likes,
    };

_PostCommentUserModel _$PostCommentUserModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_PostCommentUserModel', json, ($checkedConvert) {
  final val = _PostCommentUserModel(
    fullName: $checkedConvert('fullName', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$PostCommentUserModelToJson(
  _PostCommentUserModel instance,
) => <String, dynamic>{'fullName': instance.fullName};

_CommentsResponseModel _$CommentsResponseModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_CommentsResponseModel', json, ($checkedConvert) {
  final val = _CommentsResponseModel(
    comments: $checkedConvert(
      'comments',
      (v) => (v as List<dynamic>)
          .map((e) => PostCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$CommentsResponseModelToJson(
  _CommentsResponseModel instance,
) => <String, dynamic>{
  'comments': instance.comments.map((e) => e.toJson()).toList(),
};
