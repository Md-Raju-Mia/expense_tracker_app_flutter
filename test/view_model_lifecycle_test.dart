import 'package:fleet_wise_user_app/core/base/base_view_model.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fleet_wise_user_app/core/state/action_state.dart';
import 'support/test_actions.dart';

class TestModel extends BaseViewModel {}

void main() {
  test('failure clears loading and retry clears errors', () async {
    final model = TestModel();
    final states = <ActionStatus>[];
    model.addListener(() => states.add(model.state.status));
    final error = StateError('failure');
    final outcome = await model.execute(
      TestAction(TestTask('test', error: error)),
    );
    expect(outcome.error, same(error));
    expect(outcome.stackTrace, isNotNull);
    expect(outcome.failedTask, 'test');
    expect(model.isLoading, isFalse);
    expect(model.errorMessage, isNotNull);
    await model.execute(TestAction(TestTask('test')));
    expect(model.errorMessage, isNull);
    expect(states, [
      ActionStatus.running,
      ActionStatus.failed,
      ActionStatus.running,
      ActionStatus.succeeded,
    ]);
    model.dispose();
  });

  test('disposal stops notifications but accepted work finishes', () async {
    final model = TestModel();
    final gate = Completer<void>();
    var notifications = 0;
    model.addListener(() => notifications++);
    final pending = model.execute(TestAction(TestTask('test', gate: gate)));
    model.dispose();
    gate.complete();
    expect((await pending).isSuccess, isTrue);
    expect(model.isLoading, isFalse);
    expect(notifications, 1);
  });
}
