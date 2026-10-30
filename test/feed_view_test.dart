import 'dart:async';

import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/ui/posts/view_models/posts_view_model.dart';
import 'package:fleet_wise_user_app/ui/posts/screens/posts_screen.dart';
import 'package:fleet_wise_user_app/ui/posts/screens/post_detail_screen.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/feed_adapter.dart';

void main() {
  late FeedAdapter adapter;
  setUp(() {
    configureDependencies(getIt);
    adapter = FeedAdapter();
    getIt<Dio>().httpClientAdapter = adapter;
  });
  tearDown(() => getIt.reset());

  testWidgets('opens as a social feed without API controls', (tester) async {
    await tester.pumpWidget(const PostsApp());
    await tester.pumpAndSettle();
    expect(adapter.requests, hasLength(1));
    expect(find.text('A story from post 1'), findsOneWidget);
    expect(find.text('User 21'), findsOneWidget);
    expect(find.text('Send request'), findsNothing);
    expect(find.byType(DropdownButtonFormField), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('scroll appends without blocking feed or duplicating requests', (
    tester,
  ) async {
    await tester.pumpWidget(const PostsApp());
    await tester.pumpAndSettle();
    adapter.gate = Completer<void>();
    final list = find.byType(ListView);
    final model = tester
        .element(find.byType(PostsScreen))
        .read<PostsViewModel>();
    for (var i = 0; i < 15 && !model.isLoadingMore; i++) {
      await tester.drag(list, const Offset(0, -700));
      await tester.pump(const Duration(milliseconds: 600));
    }
    expect(model.isLoadingMore, isTrue);
    expect(
      find.descendant(
        of: find.byType(PostsScreen),
        matching: find.byType(ModalBarrier),
      ),
      findsNothing,
    );
    await tester.drag(list, const Offset(0, -300));
    await tester.pump(const Duration(milliseconds: 600));
    expect(adapter.requests, hasLength(2));
    adapter.gate!.complete();
    await tester.pumpAndSettle();
    expect(model.posts, hasLength(20));
    expect(adapter.requests.last.queryParameters['skip'], 10);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'comments open by post ID and back preserves the feed model and scroll',
    (tester) async {
      await tester.pumpWidget(const PostsApp());
      await tester.pumpAndSettle();
      final model = tester
          .element(find.byType(PostsScreen))
          .read<PostsViewModel>();
      await tester.ensureVisible(find.text('Comments').first);
      await tester.pumpAndSettle();
      final scroll = tester.widget<ListView>(find.byType(ListView)).controller!;
      final offset = scroll.offset;
      await tester.tap(find.text('Comments').first);
      await tester.pumpAndSettle();
      expect(find.byType(PostDetailScreen), findsOneWidget);
      expect(find.text('Thanks for sharing this!'), findsOneWidget);
      expect(adapter.requests.last.path, 'posts/1/comments');
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        tester.element(find.byType(PostsScreen)).read<PostsViewModel>(),
        same(model),
      );
      expect(scroll.offset, offset);
      expect(adapter.requests.where((r) => r.path == 'posts'), hasLength(1));
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('search resets paging and the filter can be cleared', (
    tester,
  ) async {
    await tester.pumpWidget(const PostsApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'love');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(adapter.requests.last.path, 'posts/search');
    expect(adapter.requests.last.queryParameters['skip'], 0);
    await tester.tap(find.byTooltip('Clear filter'));
    await tester.pumpAndSettle();
    expect(adapter.requests.last.path, 'posts');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('pull to refresh returns to the first page', (tester) async {
    await tester.pumpWidget(const PostsApp());
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 450));
    await tester.pumpAndSettle();
    expect(adapter.requests, hasLength(2));
    expect(adapter.requests.last.queryParameters['skip'], 0);
    await tester.pumpWidget(const SizedBox());
  });
}
