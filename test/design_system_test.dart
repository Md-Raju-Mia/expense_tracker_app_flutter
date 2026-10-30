import 'package:fleet_wise_user_app/core/theme/app_dimensions.dart';
import 'package:fleet_wise_user_app/core/widgets/app_page_content.dart';
import 'package:fleet_wise_user_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('page constrains width and lets lists own scrolling', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppPageContent(
            scrollable: false,
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (_, index) => Text('Row $index'),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(
      tester.getSize(find.byType(ListView)).width,
      AppLayout.contentMaxWidth - AppSpacing.xl * 2,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Row 0'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
