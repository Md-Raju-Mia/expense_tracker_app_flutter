import 'package:fleet_wise_user_app/core/base/base_view_model.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fleet_wise_user_app/core/state/action_state.dart';
import 'support/test_actions.dart';

class TestModel extends BaseViewModel {}

void main() {
  test(
    'busy guard rejects all overlapping actions without running them',
    () async {
      final model = TestModel();
      final gate = Completer<void>();
      final first = TestTask('first', gate: gate);
      final action = TestAction(first);
      final second = TestTask('second');
      final run = model.execute(action);
      await expectLater(model.execute(action), throwsStateError);
      await expectLater(model.execute(TestAction(second)), throwsStateError);
      expect(first.calls, 1);
      expect(second.calls, 0);
      expect(model.resetState(), isFalse);
      gate.complete();
      expect((await run).isSuccess, isTrue);
      expect((await model.execute(TestAction(second))).isSuccess, isTrue);
      expect(model.resetState(), isTrue);
      expect(model.state.status, ActionStatus.idle);
      model.dispose();
      await expectLater(
        model.execute(TestAction(TestTask('after disposal'))),
        throwsStateError,
      );
    },
  );
}
