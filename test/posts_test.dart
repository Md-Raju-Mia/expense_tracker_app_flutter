import 'dart:async';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/core/network/api_exception.dart';
import 'package:fleet_wise_user_app/data/models/feed_model.dart';
import 'package:fleet_wise_user_app/data/models/json_model_decoder.dart';
import 'package:fleet_wise_user_app/data/models/posts_request_model.dart';
import 'package:fleet_wise_user_app/domain/entities/posts_request.dart';
import 'package:fleet_wise_user_app/ui/posts/view_models/posts_view_model.dart';
import 'package:fleet_wise_user_app/ui/posts/view_models/post_detail_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'support/feed_adapter.dart';

void main() {
  late GetIt container;
  late FeedAdapter adapter;
  late PostsViewModel model;
  setUp(() {
    container = GetIt.asNewInstance();
    configureDependencies(container);
    adapter = FeedAdapter();
    container<Dio>().httpClientAdapter = adapter;
    model = container<PostsViewModel>();
  });
  tearDown(() async {
    if (!model.isDisposed) model.dispose();
    await container.reset();
  });

  test(
    'pages append in order, use server offsets, and stop at total',
    () async {
      await model.initialize();
      await model.loadMore();
      await model.loadMore();
      await model.loadMore();
      expect(adapter.requests.map((r) => r.queryParameters['skip']), [
        0,
        10,
        20,
      ]);
      expect(
        adapter.requests.every((r) => r.queryParameters['limit'] == 10),
        isTrue,
      );
      expect(model.posts.map((p) => p.id), List.generate(23, (i) => i + 1));
      expect(model.canLoadMore, isFalse);
    },
  );
  test(
    'duplicate IDs do not repeat cards or corrupt the next offset',
    () async {
      adapter.pages[10] = [
        postJson(10),
        ...List.generate(9, (i) => postJson(i + 11)),
      ];
      await model.initialize();
      await model.loadMore();
      expect(model.posts, hasLength(19));
      expect(model.contentState.data!.nextSkip, 20);
      await model.loadMore();
      expect(adapter.requests.last.queryParameters['skip'], 20);
    },
  );
  test('an empty page terminates even if total is stale', () async {
    adapter.pages[10] = [];
    await model.initialize();
    await model.loadMore();
    await model.loadMore();
    expect(model.posts, hasLength(10));
    expect(model.canLoadMore, isFalse);
    expect(adapter.requests, hasLength(2));
  });
  test(
    'failed append preserves feed and retries the same offset explicitly',
    () async {
      await model.initialize();
      adapter.failedSkip = 10;
      await model.loadMore();
      await model.loadMore();
      expect(model.posts, hasLength(10));
      expect(model.appendFailed, isTrue);
      expect(model.contentState.error, isA<ApiException>());
      expect(adapter.requests, hasLength(2));
      adapter.failedSkip = null;
      await model.retry();
      expect(model.posts, hasLength(20));
      expect(model.contentState.error, isNull);
      expect(adapter.requests.last.queryParameters['skip'], 10);
    },
  );
  test('overlapping scroll notifications start only one request', () async {
    await model.initialize();
    adapter.gate = Completer<void>();
    final pending = model.loadMore();
    await model.loadMore();
    await model.loadMore();
    expect(model.isLoadingMore, isTrue);
    adapter.gate!.complete();
    await pending;
    expect(adapter.requests, hasLength(2));
    expect(model.posts, hasLength(20));
  });
  test(
    'refresh waits for append then resets offset, retaining data on failure',
    () async {
      await model.initialize();
      adapter.gate = Completer<void>();
      final pending = model.loadMore();
      final refresh = model.refresh();
      adapter.gate!.complete();
      await pending;
      await refresh;
      expect(adapter.requests.map((r) => r.queryParameters['skip']), [
        0,
        10,
        0,
      ]);
      expect(model.posts, hasLength(10));
      adapter.failedSkip = 0;
      await model.refresh();
      expect(model.posts, hasLength(10));
      expect(model.appendFailed, isFalse);
    },
  );
  test(
    'search/tag filters start at zero and next pages keep their filter',
    () async {
      await model.initialize();
      await model.loadMore();
      await model.search('love & life');
      await model.loadMore();
      expect(adapter.requests[2].path, 'posts/search');
      expect(adapter.requests[2].queryParameters['skip'], 0);
      expect(adapter.requests.last.queryParameters['q'], 'love & life');
      await model.filterTag('life');
      await model.loadMore();
      expect(adapter.requests.last.path, 'posts/tag/life');
      expect(adapter.requests.last.queryParameters['skip'], 10);
      expect(model.query.search, isEmpty);
    },
  );
  test(
    'empty and malformed responses publish the correct content states',
    () async {
      adapter.total = 0;
      await model.initialize();
      expect(model.contentState.isEmpty, isTrue);
      adapter.malformed = true;
      await model.refresh();
      expect(
        (model.contentState.error as ApiException).kind,
        ApiErrorKind.invalidData,
      );
      expect(model.contentState.data!.posts, isEmpty);
    },
  );
  test(
    'disposal suppresses results and notifications from accepted work',
    () async {
      adapter.gate = Completer<void>();
      var notifications = 0;
      model.addListener(() => notifications++);
      final pending = model.initialize();
      model.dispose();
      adapter.gate!.complete();
      await pending;
      expect(notifications, 1);
      expect(model.contentState.data, isNull);
      await model.loadMore();
      expect(adapter.requests, hasLength(1));
      expect(adapter.closed, isFalse);
    },
  );
  test(
    'detail tasks fetch the requested post and its comments, retaining failures',
    () async {
      final detail = container<PostDetailViewModel>(param1: 7);
      addTearDown(detail.dispose);
      await detail.load();
      expect(detail.contentState.data!.post.id, 7);
      expect(detail.contentState.data!.comments.single.author, 'Maya Rahman');
      expect(adapter.requests.map((r) => r.path), [
        'posts/7',
        'posts/7/comments',
      ]);
      adapter.failDetail = true;
      await detail.load();
      expect(detail.contentState.error, isA<ApiException>());
      expect(detail.contentState.data!.post.id, 7);
    },
  );
  test('strict post decoder rejects malformed counters', () {
    final json = postJson(1);
    json['views'] = 'bad';
    expect(
      () => decodeJsonObject(json, PostModel.fromJson),
      throwsFormatException,
    );
  });

  test('Freezed models support JSON round-trips and immutable copies', () {
    final post = PostModel.fromJson(postJson(1));
    expect(PostModel.fromJson(post.toJson()), post);
    expect(post.copyWith(title: 'Changed').title, 'Changed');
    expect(post.title, isNot('Changed'));

    const request = PostsRequest(
      operation: PostsOperation.add,
      title: 'Title',
      body: 'Body',
      userId: 7,
    );
    final requestModel = PostsRequestModel.fromDomain(request);
    expect(PostsRequestModel.fromJson(requestModel.toJson()), requestModel);
    expect(requestModel.payload, {
      'title': 'Title',
      'body': 'Body',
      'userId': 7,
    });
  });
}
