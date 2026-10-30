import 'package:fleet_wise_user_app/core/utils/validation//forms_validators.dart';
import 'package:fleet_wise_user_app/core/presentation/app_feedback.dart';
import 'package:fleet_wise_user_app/core/storage/app_preferences.dart';
import 'package:fleet_wise_user_app/core/widgets/app_asset_image.dart';
import 'package:fleet_wise_user_app/core/widgets/app_bottom_sheet.dart';
import 'package:fleet_wise_user_app/core/widgets/app_dialog.dart';
import 'package:fleet_wise_user_app/core/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  group('AppValidators', () {
    test('composes required and format validation with caller messages', () {
      final validator = FormsValidators.combine([
        FormsValidators.required(message: 'required'),
        FormsValidators.email(message: 'invalid'),
      ]);

      expect(validator(null), 'required');
      expect(validator('not-an-email'), 'invalid');
      expect(validator(' person@example.com '), isNull);
    });

    test('supports optional, phone, and length validation', () {
      final optionalPhone = FormsValidators.optional(
        FormsValidators.phone(message: 'invalid phone'),
      );
      final length = FormsValidators.combine([
        FormsValidators.minLength(2, message: 'short'),
        FormsValidators.maxLength(4, message: 'long'),
      ]);

      expect(optionalPhone(''), isNull);
      expect(optionalPhone('+880 1712-345678'), isNull);
      expect(optionalPhone('abc'), 'invalid phone');
      expect(length('a'), 'short');
      expect(length('abcde'), 'long');
      expect(length('abc'), isNull);
    });
  });

  testWidgets('asset image selects the SVG renderer by extension', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppAssetImage(
          assetPath: 'assets/missing.svg',
          semanticLabel: 'Example image',
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('network image exposes consistent loading and error states', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    final rendered = const AppNetworkImage(
      url: 'https://example.test/image.png',
      width: 80,
      height: 80,
      semanticLabel: 'Example image',
    ).build(context);
    final image = (rendered as ClipRRect).child! as Image;

    final loading = image.loadingBuilder!(
      context,
      const SizedBox.shrink(),
      const ImageChunkEvent(cumulativeBytesLoaded: 5, expectedTotalBytes: 10),
    );
    final error = image.errorBuilder!(context, StateError('failed'), null);

    expect(loading, isA<SizedBox>());
    expect(error, isA<SizedBox>());
    expect(image.semanticLabel, 'Example image');
  });

  testWidgets('dialog and bottom sheet return typed results', (tester) async {
    String? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () async {
                    result = await showAppDialog<String>(
                      context,
                      title: const Text('Question'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'dialog'),
                          child: const Text('Dialog result'),
                        ),
                      ],
                    );
                  },
                  child: const Text('Open dialog'),
                ),
                TextButton(
                  onPressed: () async {
                    result = await showAppBottomSheet<String>(
                      context,
                      builder: (sheetContext) => TextButton(
                        onPressed: () => Navigator.pop(sheetContext, 'sheet'),
                        child: const Text('Sheet result'),
                      ),
                    );
                  },
                  child: const Text('Open sheet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsOneWidget);
    await tester.tap(find.text('Dialog result'));
    await tester.pumpAndSettle();
    expect(result, 'dialog');

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sheet result'));
    await tester.pumpAndSettle();
    expect(result, 'sheet');
  });

  testWidgets('feedback uses a live-region snackbar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => AppFeedback.show(
                context,
                message: 'Saved',
                kind: AppFeedbackKind.success,
              ),
              child: const Text('Save'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(
      tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((semantics) => semantics.properties.liveRegion == true),
      isTrue,
    );
  });

  test('preferences persist supported non-sensitive value types', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    addTearDown(() => SharedPreferencesAsyncPlatform.instance = null);
    final preferences = SharedPreferencesAppPreferences();

    await preferences.setBool('enabled', true);
    await preferences.setInt('count', 3);
    await preferences.setDouble('ratio', 1.5);
    await preferences.setString('name', 'worker');
    await preferences.setStringList('tags', ['a', 'b']);

    expect(await preferences.getBool('enabled'), isTrue);
    expect(await preferences.getInt('count'), 3);
    expect(await preferences.getDouble('ratio'), 1.5);
    expect(await preferences.getString('name'), 'worker');
    expect(await preferences.getStringList('tags'), ['a', 'b']);
    await preferences.remove('enabled');
    expect(await preferences.getBool('enabled'), isNull);
  });
}
