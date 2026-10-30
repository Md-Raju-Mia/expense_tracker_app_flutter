# Project memory: Java Android to Flutter

This file records durable project intent and decisions. Read [MIGRATION.md](MIGRATION.md) for the workflow. Update this file after each module decision or milestone.

## Mission

- The existing Java Android iFleet User App is working in production. Preserve its observable business behavior and backend contracts while migrating. Its MVP/package structure is discovery material, **not** the target architecture.
- Migrate one bounded business module at a time, each with an independent parity checklist and tests. Do not rewrite the whole app in one change.
- Legacy source of truth: [raju-UserApp](https://github.com/bucketnexkraft/nexfleet-user-app/tree/raju-UserApp). Pin a source commit per module.
- The architecture already established in this Flutter project is authoritative for every migrated module: Provider MVVM, get_it composition, go_router routing, the ui -> domain <- data layer direction, shared Dio, and existing state contracts. Do not port Java MVP presenters, repository classes, or package boundaries one-for-one. Its posts feed uses DummyJSON; it is sample code, not a migrated iFleet feature.
- Follow [ARCHITECTURE.md](ARCHITECTURE.md), [NETWORKING.md](NETWORKING.md), [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md), and [LOCALIZATION.md](LOCALIZATION.md) when changing relevant code.

## Verified baseline, 14 September 2026

Legacy commit: [2971956d9fb1c797a32c5fc7dd76a8d0fa407aad](https://github.com/bucketnexkraft/nexfleet-user-app/tree/2971956d9fb1c797a32c5fc7dd76a8d0fa407aad). The legacy README describes an MVP/Retrofit/Firebase app. Java UI packages include login, home, requisition, createRequisition, trip, pickNdrop, shohochor, ifleetDefect, workshopDefect, notification, and mechanics. API declarations are in app/src/main/java/com/nexkraft/ifleetUser/api/rest/RetrofitAPI.java; feature repositories are under api/repo. Native/state components include prefs, room, LocationService.java, and IfleetUserFirebaseMessagingService.java.

Legacy Android applicationId is com.nexkraft.ifleetUser, versionCode 100, versionName 2.97. The Flutter template uses com.nexkraft.fleet_wise_user_app and 1.0.0+1. Production identity, signing, version-code, and on-device data upgrade are open decisions. Do not call this template a drop-in production update.

The Flutter template pins FVM Flutter 3.47.1 and uses Provider MVVM, get_it, go_router, Dio, Freezed DTOs, and English/Bengali ARB localization. Its root app and initial route still use the sample posts feature. No iFleet module has been verified as migrated.

## Decision and status log

| Item | State | Next action |
| --- | --- | --- |
| Migration unit | One bounded module/journey | Use the slice and exit gates in MIGRATION.md. |
| Release path | Undecided | Choose native/Flutter coexistence or sequential development of a replacement app. |
| Production identity/signing | Undecided | Verify Play Console package, signing lineage, version code, and upgrade data. Never copy signing keys into this repo. |
| Auth/session migration | Undecided | Map token storage, expiry, refresh, logout, and upgrade behavior. |
| First module | Undecided | Inventory dependencies and select a low-risk slice after auth/navigation mapping. |
| Completed modules | None verified | Record each slice, source commit, tests, and release evidence here. |

Never put credentials, tokens, signing files, or real user data in this memory.

## Current shared migration conventions

- Keep conversion-created raster and SVG assets in `assets/images/` and font files in `assets/fonts/`; never create feature-specific asset directories.
- Create workflow actions only in `lib/domain/actions`, named `<Feature><Purpose>Action` without a `Run` or `run_` prefix. Inject their tasks and compose them with `TaskChain` and `runTask`.
- Place each feature task in `lib/domain/tasks/<feature>`, never directly under `lib/domain/tasks` or in the UI layer.
- The Java User app is the source of observable behavior. The Flutter template, including its posts/DummyJSON feature, does not define User-app contracts.


## Architecture alignment, 30 October 2026
- Aligned sample posts code and guides: PostsWriteAction lives in lib/domain/actions; feature tasks live in lib/domain/tasks/posts. Navigation and localized messages remain in presentation.
