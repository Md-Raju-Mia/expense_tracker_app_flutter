import 'package:fleet_wise_user_app/core/widgets/paging_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'underfilled viewport requests another page and stops when exhausted',
    (tester) async {
      var calls = 0;
      var more = true;
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return PagingView(
                  itemCount: 1,
                  itemBuilder: (_, _) => const Text('Short post'),
                  header: const SizedBox(),
                  footer: const SizedBox(),
                  canLoadNextPage: more,
                  onLoadNextPage: () async {
                    calls++;
                    update(() => more = false);
                  },
                  onRefresh: () async {},
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(calls, 1);
      await tester.pump(const Duration(seconds: 2));
      expect(calls, 1);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('leaving the page cancels its pending debounce', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PagingView(
            itemCount: 0,
            itemBuilder: (_, _) => const SizedBox(),
            header: const SizedBox(),
            footer: const SizedBox(),
            canLoadNextPage: true,
            onLoadNextPage: () async {
              calls++;
            },
            onRefresh: () async {},
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    expect(calls, 0);
  });
}
