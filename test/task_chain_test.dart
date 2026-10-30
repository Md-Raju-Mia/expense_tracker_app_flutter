import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fleet_wise_user_app/core/base/task_chain.dart';

void main() {
  test('chain is lazy, ordered, and passes typed results', () async {
    final gate = Completer<int>();
    final events = <String>[];
    final chain =
        TaskChain.start(() {
              events.add('first');
              return gate.future;
            })
            .add((value) {
              events.add('second');
              return 'value:$value';
            })
            .add((text) => text.length);
    expect(events, isEmpty);
    final Future<int> result = chain.execute();
    expect(events, ['first']);
    gate.complete(42);
    expect(await result, 8);
    expect(events, ['first', 'second']);
  });

  test(
    'sync and async failures stop later steps and preserve errors',
    () async {
      for (final asynchronous in [false, true]) {
        final error = StateError('failed');
        final trace = StackTrace.current;
        final chain = TaskChain<int>.start(() => 1)
            .add<int>((_) {
              if (asynchronous) return Future<int>.error(error, trace);
              Error.throwWithStackTrace(error, trace);
            })
            .add<void>((_) => fail('must not run'));
        try {
          await chain.execute();
          fail('must fail');
        } catch (caught, stackTrace) {
          expect(caught, same(error));
          expect(stackTrace.toString(), trace.toString());
        }
      }
    },
  );

  test(
    'repeated execution starts fresh and supports nullable outputs',
    () async {
      var calls = 0;
      final chain = TaskChain.start(() => ++calls).add<String?>((_) => null);
      expect(await chain.execute(), isNull);
      expect(await chain.execute(), isNull);
      expect(calls, 2);
    },
  );

  test('void final step represents completed side effect', () async {
    var uploaded = false;
    final Future<void> result = TaskChain.start(() => 42).add<void>((_) async {
      uploaded = true;
    }).execute();
    await result;
    expect(uploaded, isTrue);
  });
}
