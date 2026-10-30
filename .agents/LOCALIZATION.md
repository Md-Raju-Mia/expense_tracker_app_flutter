# Localization instructions for agents

## User migration override

Converted iFleet User screens must show the same text and language behavior as the production Java app. The template's English/Bengali setup is an implementation tool, not authority to add translations, rewrite copy, or alter fallback behavior during conversion.

Use Flutter gen-l10n. Source messages live in lib/l10n/app_en.arb and app_bn.arb.
English is the template and fallback; Bengali is the second supported language,
matching the reference template. The root app follows the device locale.

For every new UI string, add a descriptive key to both ARB files. Include
translator descriptions in the English template and typed placeholders for
variable values. Use ICU plurals/selects for grammar; never concatenate translated
fragments. Use intl for localized number/date formatting when needed.

Run `flutter gen-l10n` after editing ARB files. Generated source is in
lib/l10n/generated and is checked in; do not edit generated Dart manually.
Import `package:fleet_wise_user_app/l10n/l10n.dart` in presentation code and access
`context.l10n.messageKey`. Widget tests must configure generated localization
delegates and supportedLocales on their MaterialApp wrappers.

Keep BuildContext and localized strings out of tasks, actions, remote sources,
and DI. Feature screens override BaseView.operationLabel to translate task names; unknown operations receive the generic label. BaseView.errorMessage uses localizedErrorMessage in lib/core/presentation/error_message.dart for ApiErrorKind feedback. Override errorMessage for feature-specific failures or return null to suppress feedback. Resolve messages during build so locale changes update existing errors. Cancellation has neutral feedback and does not imply rollback.
BaseViewModel.errorMessage and ApiException.message are diagnostic English
strings, not the UI translation source. Keep the original error for debugging.

Use direction-aware padding/alignment for new directional layouts. Allow text
to wrap and scroll. Verify Bengali at narrow widths and enlarged text, English
fallback for unsupported locales, and updates after the system locale changes.

For another language: add a complete app_<locale>.arb, regenerate, and update
iOS CFBundleLocalizations/knownRegions. MaterialApp uses generated locale lists;
no hand-maintained Dart locale list is required. Native launcher app names are
separate from Flutter's localized onGenerateTitle and are not translated here.

Run flutter analyze and flutter test. Tests must check ARB key parity and locale
behavior. The platform supplies fonts for Bengali; tests validate text/layout,
not a production Bengali font rendering baseline.

Reference: https://docs.flutter.dev/ui/internationalization

