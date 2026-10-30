# Agent instructions

## Current User migration conventions

These rules supersede older conflicting guidance. Use `UserAppJava` as the Java behavior and UI reference; preserve observable behavior and known defects.
Create workflow actions only in `lib/domain/actions`, named `<Feature><Purpose>Action` without a `Run` or `run_` prefix; inject tasks and compose them with `TaskChain` and `runTask`.
Place each feature task in `lib/domain/tasks/<feature>`, never directly under `lib/domain/tasks` or in the UI layer.
Keep raster and SVG visuals in `assets/images/` and font files in `assets/fonts/`; do not create feature-specific asset directories.
The posts/DummyJSON feature is sample code, not a source of truth for a migrated User module.

## Migration mission and memory

This Flutter project is the target for a **module-by-module migration** of the
production Java Android iFleet User App. Read [MEMORY.md](MEMORY.md) and
[MIGRATION.md](MIGRATION.md) before planning or implementing a legacy feature.
Use [../tutorial.md](../tutorial.md) when handing a module to a junior developer.
Treat the legacy branch as the behavior and API reference, never as the target architecture. Preserve the Flutter architecture in ARCHITECTURE.md; the posts/DummyJSON feature
is sample code, not a migrated production module.

## Architecture

Before changing application code or tests, read [ARCHITECTURE.md](ARCHITECTURE.md).
It defines feature structure, navigation ownership, dependency injection,
task/action contracts, disposal, and testing requirements for all features.

## Feature presentation structure

Put route-level BaseView screens in lib/ui/<feature>/screens and focused,
feature-specific components in lib/ui/<feature>/widgets. Keep screens short:
they should compose widgets, connect the route view model, and own navigation.
Extract cohesive sections such as search, status, cards, and comments into
named widgets. Use lib/core/widgets only for components shared across features.

## UI generation

Before creating or modifying any screen, widget, layout, or visual style:
1. Read DESIGN_SYSTEM.md and the shared theme, dimensions, and relevant widgets.
2. Inspect the nearest existing feature and reuse its composition and lifecycle.
3. Implement the requested UI using the design guide's semantic colors,
   typography, layout tokens, and shared components.
4. Verify the affected UI as described in the guide. Keep documentation in sync
   when intentionally changing shared design rules.

DESIGN_SYSTEM.md is the agent's repository-wide UI generation specification.
Apply it automatically; the user does not need to mention it
or restate styling requirements for each screen. Explicit user requirements
take priority over these defaults. Make routine design decisions using the
existing conventions and keep work within the requested feature scope.

## Networking

For HTTP integrations, read NETWORKING.md first. Inject the shared ApiClient;
keep endpoint contracts and model decoding in feature tasks/remote sources.

## Localization

Read LOCALIZATION.md for every user-facing text change. Use generated ARB
messages through context.l10n; keep all supported translations complete.
Guide links in this file are relative to .agents; source paths in guides are
relative to the repository root.


