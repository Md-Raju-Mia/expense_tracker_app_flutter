import 'dart:async';

import 'package:fleet_wise_user_app/core/base/content_view_model.dart';
import 'package:fleet_wise_user_app/core/state/action_state.dart';
import 'package:fleet_wise_user_app/core/state/content_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_actions.dart';

class CountViewModel extends ContentViewModel<int> {
  @override
  bool isEmptyResult(int data) => data == 0;
}

void main() {
  test('initial load, content, and empty results', () async {
    final model = CountViewModel();
    addTearDown(model.dispose);
    expect(model.contentState.isInitialLoading, isTrue);
    expect(model.contentState.hasData, isFalse);
    final statuses = <ContentStatus>[];
    model.addListener(() => statuses.add(model.contentState.status));
    await model.loadContent(TestTask('load', value: 3));
    expect(model.contentState.data, 3);
    await model.loadContent(TestTask('empty', value: 0));
    expect(model.contentState.isEmpty, isTrue);
    expect(model.contentState.data, 0);
    expect(statuses, [
      ContentStatus.initialLoading,
      ContentStatus.content,
      ContentStatus.refreshing,
      ContentStatus.empty,
    ]);
  });

  for (final previous in [0, 3]) {
    test(
      'refresh retains $previous on failure and clears errors on retry',
      () async {
        final model = CountViewModel();
        addTearDown(model.dispose);
        await model.loadContent(TestTask('load', value: previous));
        final gate = Completer<void>();
        final failure = StateError('offline');
        final pending = model.loadContent(
          TestTask('refresh', gate: gate, error: failure),
        );
        expect(model.contentState.isRefreshing, isTrue);
        expect(model.contentState.data, previous);
        expect(model.isLoading, isFalse);
        gate.complete();
        final outcome = await pending;
        expect(outcome.error, same(failure));
        expect(outcome.stackTrace, isNotNull);
        expect(model.contentState.data, previous);
        expect(model.isFetching, isFalse);
        final retry = model.loadContent(TestTask('retry', value: 4));
        expect(model.contentState.error, isNull);
        expect(model.contentState.data, previous);
        await retry;
        expect(model.contentState.data, 4);
      },
    );
  }

  test('initial failure retries as initial loading', () async {
    final model = CountViewModel();
    addTearDown(model.dispose);
    await model.loadContent(TestTask('load', error: StateError('offline')));
    expect(model.contentState.hasError, isTrue);
    expect(model.contentState.hasData, isFalse);
    final pending = model.loadContent(TestTask('retry'));
    expect(model.contentState.isInitialLoading, isTrue);
    await pending;
  });

  test('overlapping loads reject without running task', () async {
    final model = CountViewModel();
    addTearDown(model.dispose);
    final gate = Completer<void>();
    final pending = model.loadContent(TestTask('load', gate: gate));
    final rejected = TestTask('overlap');
    await expectLater(model.loadContent(rejected), throwsStateError);
    expect(rejected.calls, 0);
    gate.complete();
    await pending;
  });

  test('workflow and content states are independent', () async {
    final model = CountViewModel();
    addTearDown(model.dispose);
    final gate = Completer<void>();
    final pending = model.loadContent(TestTask('load', gate: gate));
    final result = await model.execute(TestAction(TestTask('end trip')));
    expect(result.isSuccess, isTrue);
    expect(model.contentState.isInitialLoading, isTrue);
    gate.complete();
    await pending;
    expect(model.state.status, ActionStatus.succeeded);
    model.resetState();
    expect(model.contentState.data, 1);
  });

  test('disposed models suppress publication and reject new loads', () async {
    final model = CountViewModel();
    final gate = Completer<void>();
    var notifications = 0;
    model.addListener(() => notifications++);
    final pending = model.loadContent(TestTask('load', gate: gate));
    model.dispose();
    gate.complete();
    expect((await pending).data, 1);
    expect(notifications, 1);
    expect(model.contentState.hasData, isFalse);
    expect(model.isFetching, isFalse);
    final rejected = TestTask('disposed');
    await expectLater(model.loadContent(rejected), throwsStateError);
    expect(rejected.calls, 0);
  });
}
