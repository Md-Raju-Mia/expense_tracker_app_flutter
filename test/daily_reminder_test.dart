import 'package:fleet_wise_user_app/core/theme/app_theme.dart';
import 'package:fleet_wise_user_app/core/utils/platform/android_daily_reminder.dart';
import 'package:fleet_wise_user_app/data/repositories/daily_reminder_repository_impl.dart';
import 'package:fleet_wise_user_app/domain/actions/reminder_save_action.dart';
import 'package:fleet_wise_user_app/domain/tasks/reminder/load_daily_reminder_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/reminder/save_daily_reminder_task.dart';
import 'package:fleet_wise_user_app/l10n/l10n.dart';
import 'package:fleet_wise_user_app/ui/preferences/view_models/daily_reminder_view_model.dart';
import 'package:fleet_wise_user_app/ui/preferences/widgets/daily_reminder_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/load_expense_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadExpenseFonts);

  const channel = MethodChannel('expense_tracker/daily_reminder');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  testWidgets('shows permission status, reloads saved time and switches off', (
    tester,
  ) async {
    var enabled = false;
    var allowed = false;
    var minutes = 1200;
    final writes = <(bool, int)>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'save') {
        final arguments = call.arguments as Map<Object?, Object?>;
        enabled = arguments['enabled'] as bool;
        minutes = arguments['minutes'] as int;
        writes.add((enabled, minutes));
      } else {
        expect(call.method, 'load');
      }
      return {'enabled': enabled, 'allowed': allowed, 'minutes': minutes};
    });

    const repository = DailyReminderRepositoryImpl(AndroidDailyReminder());

    Future<void> openSettings(String language) async {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(language),
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: language == 'bn' ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: ChangeNotifierProvider(
            create: (_) => DailyReminderViewModel(
              const LoadDailyReminderTask(repository),
              (enabled, minutes) => ReminderSaveAction(
                SaveDailyReminderTask(repository, enabled, minutes),
              ),
            )..load(),
            child: const Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: DailyReminderSection(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await openSettings('en');

    final toggle = find.byType(SwitchListTile);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(toggle).value, isTrue);
    expect(find.textContaining('Notifications are blocked'), findsOneWidget);
    expect(writes, [(true, 1200)]);

    allowed = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.textContaining('Android may deliver'), findsOneWidget);

    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '9');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.textContaining('9:00'), findsOneWidget);
    expect(writes.last, (true, 1260));

    await openSettings('bn');
    expect(find.text('দৈনিক রিমাইন্ডার'), findsOneWidget);
    expect(tester.widget<SwitchListTile>(toggle).value, isTrue);
    expect(
      tester.element(toggle).read<DailyReminderViewModel>().reminder?.minutes,
      1260,
    );
    expect(find.textContaining('রিমাইন্ডারের সময়'), findsOneWidget);
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    final pickerContext = tester.element(find.byType(TimePickerDialog));
    expect(Localizations.localeOf(pickerContext).languageCode, 'bn');
    Navigator.of(pickerContext).pop();
    await tester.pumpAndSettle();
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(toggle).value, isFalse);
    expect(writes.last, (false, 1260));
    expect(tester.takeException(), isNull);
  });
}
