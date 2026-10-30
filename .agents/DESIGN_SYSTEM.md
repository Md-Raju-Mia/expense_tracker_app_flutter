# UI generation specification for agents

## User migration override

A converted iFleet User screen must reproduce the production Java UI exactly: layout, colors, typography, icons, spacing, text, states, and navigation. Template design tokens and shared widgets are implementation aids only when they yield the same visible result. Do not restyle, modernize, or correct the Java UI during conversion.

Audience: coding agents generating or modifying UI in this repository.
Apply these rules automatically to every screen and reusable widget. The user
should not need to reference this file or repeat styling instructions.

## Required generation workflow

- Read this guide, AppTheme, AppSpacing/AppLayout, and the relevant existing UI.
- Map the requested content and interactions to existing Material components.
  Reuse BaseView for MVVM screens and AppPageContent for standard page bodies.
- Use ColorScheme and TextTheme roles plus shared dimensions. Keep visual
  decisions consistent across features; do not invent per-screen style systems.
- Preserve requested behavior and account for applicable loading, error, empty,
  disabled, and success states without adding unrequested product features.
- Verify affected layouts in light/dark mode and at narrow widths with enlarged
  text. Run analysis and relevant tests; inspect visual output when changing
  shared styling. Perform these checks as agent work, not a user prerequisite.
- When a requested design requires new reusable styling, define it centrally
  and update this guide. Explicit user design requirements override defaults.

## Runtime implementation
Runtime styling lives in `lib/core/theme/app_theme.dart`; layout tokens live in `lib/core/theme/app_dimensions.dart`. Markdown guides
implementation; Flutter does not load this file at runtime.

## App theme

`PostsApp` applies `AppTheme.light`, `AppTheme.dark`, and `ThemeMode.system` to
`MaterialApp.router`. All routes inherit it. Keep one root MaterialApp per app entry point; do not
create another inside a feature. Retain Material 3 and the default platform font.
Both palettes are generated from `AppTheme.seedColor` (teal). Change the seed in
one place to change the app palette. No font downloads are required.

Read styling with `Theme.of(context)` so widgets respond to brightness changes.
Do not resolve ThemeData through get_it or cache a context-derived theme globally.

## Colors and typography

Use semantic ColorScheme roles, never feature-specific hex colors or Colors.*:

| Purpose | Roles |
| --- | --- |
| Page and ordinary text | surface / onSurface |
| Cards | surfaceContainerLow / onSurface |
| Supporting text | onSurfaceVariant |
| Primary action | primary / onPrimary (inherited by FilledButton) |
| Error feedback | errorContainer / onErrorContainer |
| Loading scrim | scrim with 0.32 alpha |

Use TextTheme roles: headlineSmall for prominent status or section headings,
titleLarge for page titles, titleMedium for smaller headings, bodyLarge/bodyMedium
for content, and labelLarge for button labels. Material components inherit their
styles. Use copyWith for semantic foreground colors; define shared size, weight,
and font changes in AppTheme instead of individual screens.

## Layout and components

Use AppSpacing: xs=4, sm=8, md=12, lg=16, xl=24, xxl=32 logical pixels.
Standard screen padding is xl, content gaps are md/lg, and section gaps are xl/xxl.
Simple single-column forms and detail screens use AppLayout.contentMaxWidth=640 (including page padding); adapt
multi-column layouts to available constraints. Shared AppLayout.cornerRadius is 12.

Use Material components and their global component themes for app bars, cards,
buttons, and text inputs. Buttons have a minimum height of 48 and can grow with
text. Do not fix text-containing controls to a height that clips large text.
Use FilledButton for the main action, OutlinedButton for secondary actions, and
TextButton for low-emphasis actions. Keep disabled/focus/hover states provided by
Material. Add reusable styling in AppTheme before duplicating widget overrides.

Feature-specific sections live under `lib/ui/<feature>/widgets`;
route-level screens live under `lib/ui/<feature>/screens`.
Shared presentation helpers live under `lib/core/widgets`: `AppNetworkImage`
and `AppAssetImage` provide consistent image states, while `AppDialog` and
`showAppBottomSheet` retain native Material layout and accessibility behavior.
Callers provide localized text and semantic labels. Use `AppFeedback` only for
transient success, information, or warning messages; operation errors remain in
BaseView's persistent, localized error region.

Use BaseView for MVVM screens to retain SafeArea, loading, and error behavior.
Allow content to wrap and scroll; retain system text scaling. Do not communicate
state by color alone. Theme-sensitive code belongs in presentation, not tasks.

## New screen pattern

```dart
final theme = Theme.of(context);
return AppPageContent(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Screen title', style: theme.textTheme.headlineSmall),
      const SizedBox(height: AppSpacing.lg),
      Text('Description', style: theme.textTheme.bodyMedium),
      const SizedBox(height: AppSpacing.xl),
      FilledButton(onPressed: onContinue, child: const Text('Continue')),
    ],
  ),
);
```

Import Flutter Material, the shared theme file, and `core/widgets/app_page_content.dart`. The example belongs in a
screen body below the root MaterialApp. For an intentional local variation,
extend `Theme.of(context).copyWith(...)`; preserve light/dark behavior and explain
why the variation is needed. Never introduce a separate feature palette silently.

## Verification and maintenance

Check light/dark appearances, narrow layouts, enlarged text, and loading/error/
disabled states. Run flutter analyze and relevant widget tests after UI changes.
Update this guide when shared tokens or component conventions change.

Reference: https://docs.flutter.dev/cookbook/design/themes

## Shared page layout

Use `AppPageContent(child: ...)` for simple forms and detail screens. It provides
24-pixel padding, a centered width capped at 640 pixels including padding, and
vertical scrolling. It defaults to top alignment; use `Alignment.center` for a
centered short screen. BaseView already supplies SafeArea.

The posts feed uses AppPageContent(scrollable: false, padding: EdgeInsets.zero)
with PagingView owning scrolling and token-based list padding. PostCard uses
the shared Card theme, a wrapping statistics/actions row, and full-width text.
API controls and diagnostic JSON do not belong in the social feed.

For `ListView` or another scrollable child, use `scrollable: false`; the child
owns scrolling and must receive bounded height from the screen. Avoid Expanded
inside the default scrolling Column. Use padding/maxWidth overrides only when
the screen requires them. Do not put a MaterialApp inside a feature screen.

## Agent verification

Run `flutter test` to verify theme switching, narrow layouts, enlarged text,
and shared page scrolling. Inspect the actual affected screens when changing UI.

## Localized UI

Read LOCALIZATION.md alongside this guide. Use context.l10n for all visible
strings, input labels, hints, validation messages, and accessibility labels.
The illustrative English literals in the layout example represent ARB messages;
replace them with the feature's localization keys in generated screens.
