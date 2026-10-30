import 'dart:async';
import 'package:fleet_wise_user_app/core/base/base_action.dart';
import 'package:fleet_wise_user_app/core/base/base_task.dart';

class TestTask extends BaseTask<int> {
  TestTask(this.name, {this.gate, this.error, this.value = 1, this.events});
  @override
  final String name;
  final Completer<void>? gate;
  Object? error;
  final int value;
  final List<String>? events;
  int calls = 0;

  @override
  Future<int> run() async {
    calls++;
    events?.add(name);
    if (gate != null) await gate!.future;
    if (error != null) throw error!;
    return value;
  }
}

class TestAction extends BaseAction {
  TestAction(this.first, [this.second]);
  final TestTask first;
  final TestTask? second;
  int? result;

  @override
  Future<void> run() async {
    result = await runTask(first);
    if (second != null) result = await runTask(second!);
  }
}
