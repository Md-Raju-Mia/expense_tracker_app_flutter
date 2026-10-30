// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostsRequestModel _$PostsRequestModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PostsRequestModel', json, ($checkedConvert) {
      final val = _PostsRequestModel(
        operation: $checkedConvert(
          'operation',
          (v) => $enumDecode(_$PostsOperationEnumMap, v),
        ),
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        query: $checkedConvert('query', (v) => v as String),
        limit: $checkedConvert('limit', (v) => (v as num).toInt()),
        skip: $checkedConvert('skip', (v) => (v as num).toInt()),
        sortBy: $checkedConvert('sortBy', (v) => v as String),
        order: $checkedConvert('order', (v) => v as String),
        select: $checkedConvert('select', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
        userId: $checkedConvert('userId', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PostsRequestModelToJson(_PostsRequestModel instance) =>
    <String, dynamic>{
      'operation': _$PostsOperationEnumMap[instance.operation]!,
      'id': instance.id,
      'query': instance.query,
      'limit': instance.limit,
      'skip': instance.skip,
      'sortBy': instance.sortBy,
      'order': instance.order,
      'select': instance.select,
      'title': instance.title,
      'body': instance.body,
      'userId': instance.userId,
    };

const _$PostsOperationEnumMap = {
  PostsOperation.list: 'list',
  PostsOperation.single: 'single',
  PostsOperation.search: 'search',
  PostsOperation.tags: 'tags',
  PostsOperation.tagList: 'tagList',
  PostsOperation.byTag: 'byTag',
  PostsOperation.byUser: 'byUser',
  PostsOperation.comments: 'comments',
  PostsOperation.add: 'add',
  PostsOperation.update: 'update',
  PostsOperation.delete: 'delete',
};

_PostsResponseModel _$PostsResponseModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PostsResponseModel', json, ($checkedConvert) {
      final val = _PostsResponseModel(
        data: $checkedConvert('data', (v) => v as Object),
        statusCode: $checkedConvert('statusCode', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PostsResponseModelToJson(_PostsResponseModel instance) =>
    <String, dynamic>{'data': instance.data, 'statusCode': instance.statusCode};
