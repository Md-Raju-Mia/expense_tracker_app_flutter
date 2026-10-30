import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fleet_wise_user_app/core/base/base_task.dart';
import 'package:fleet_wise_user_app/domain/entities/feed.dart';

class EmptyFeedTask extends BaseTask<FeedPage> {
  @override
  String get name => 'Load posts';
  @override
  Future<FeedPage> run() async => FeedPage(
    posts: [],
    nextSkip: 0,
    total: 0,
    hasMore: false,
    query: const FeedQuery(),
  );
}

Map<String, dynamic> postJson(int id) => {
  'id': id,
  'userId': id + 20,
  'title': 'A story from post $id',
  'body':
      'A small moment can change the way we see the world. Today I took a different path home and found something worth sharing with everyone.',
  'tags': ['life', 'stories'],
  'reactions': {'likes': 120 + id, 'dislikes': 2},
  'views': 400 + id,
};

class FeedAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  final pages = <int, List<Map<String, dynamic>>>{};
  int total = 23;
  int? failedSkip;
  bool failDetail = false;
  bool malformed = false;
  Completer<void>? gate;
  bool closed = false;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    await gate?.future;
    final skip = options.queryParameters['skip'] as int? ?? 0;
    final limit = options.queryParameters['limit'] as int? ?? 10;
    final id = int.tryParse(options.path.split('/').last);
    Object data;
    int status = 200;
    if (options.path.endsWith('/comments')) {
      data = {
        'comments': [
          {
            'id': 1,
            'body': 'Thanks for sharing this!',
            'likes': 4,
            'user': {'fullName': 'Maya Rahman'},
          },
        ],
        'total': 1,
        'skip': 0,
        'limit': 1,
      };
    } else if (id != null && !options.path.contains('/user/')) {
      data = postJson(id);
      if (failDetail) status = 404;
    } else {
      final count = max(0, min(limit, total - skip));
      data = {
        'posts':
            pages[skip] ??
            List.generate(count, (index) => postJson(skip + index + 1)),
        'total': total,
        'skip': skip,
        'limit': limit,
      };
      if (failedSkip == skip) status = 500;
    }
    if (malformed) data = {'posts': 'invalid'};
    return ResponseBody.fromString(
      jsonEncode(data),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {
    closed = true;
  }
}
