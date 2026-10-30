# Module-by-module migration playbook

## Objective and source

Replace the production Java Android iFleet User App with Flutter in controlled, reviewable slices. Preserve business rules, API behavior, permissions, and user journeys. **Use the architecture already established in this Flutter repository, not the Java MVP architecture.** Java classes and packages help locate behavior; they are not a blueprint for Dart classes or folders. Record intentional behavior changes separately from parity work.

Legacy source: [raju-UserApp](https://github.com/bucketnexkraft/nexfleet-user-app/tree/raju-UserApp). This inventory was checked at [commit 2971956](https://github.com/bucketnexkraft/nexfleet-user-app/tree/2971956d9fb1c797a32c5fc7dd76a8d0fa407aad) on 14 September 2026. Pin the current commit when starting each module. The production binary and observed backend behavior are also references when source and reality differ.

## Choose a release path before shipping

“Module by module” is the engineering unit; it does not itself make a standalone Flutter app an incremental update to the Java app.

1. **Native/Flutter coexistence:** Embed a Flutter module in the production Android app and route selected journeys to Flutter. Define ownership of session, navigation, back stack, notifications, location, and bridge contracts. This permits feature-level rollout but adds native/Flutter build and lifecycle complexity.
2. **Separate Flutter replacement:** Develop and validate modules sequentially in this repo while Java remains production. Ship the replacement only after every required production journey and upgrade gate passes. Internal tracks and flags may expose partial work to testers, not to production users who need the missing flows.

Record the selected path, rollout owner, flag, and rollback mechanism. Do not silently change paths halfway through a module.

## Legacy discovery map

This map identifies starting points, not completed contract analysis. For each slice trace its Activity/Fragment, presenter, repository, Retrofit method, models, layouts/resources, manifest entries, and callers.

| Area | Legacy starting points | Dependency concerns |
| --- | --- | --- |
| Entry/auth/home | ui/splash, ui/onBoarding, ui/login, ui/forgot_pass, ui/home, api/repo/UserRepository.java | OTP, session, role routing, deep links |
| Requisitions | ui/requisition, ui/createRequisition, RequisitionRepository.java | Multi-step forms, validation, dates, approvals |
| Trips/location/SOS | ui/trip, service/LocationService.java | Foreground service, permissions, background lifecycle |
| Pick and drop | ui/pickNdrop | Booking and trip state |
| Shohochor | ui/shohochor, res/navigation/shohochor_navigation.xml | Seat buy/sell/transfer, history |
| Defects | ui/ifleetDefect, ui/workshopDefect | Approval/rejection rules, reasons, status transitions |
| Notifications | ui/notification, service/firebase/IfleetUserFirebaseMessagingService.java | FCM registration, payload routing, background delivery |
| Mechanics | ui/mechanics | Jobs, leave, outside visit, overtime, TADA, role gating |
| Supporting | ui/summary, ui/statement, ui/feedback, ui/phoneBook, ui/faq, ui/adminSupport | Shared session, data, dialing, localization |

Start with a low-risk, bounded vertical slice after mapping shared authentication and navigation. A read-only supporting journey may be suitable. Background location, SOS, and broad multi-step writes need more platform and operational design.

## Workflow for every module

### 1. Capture the contract

Create .agents/modules/<module>.md from the template below. Pin the legacy commit and source paths. Observe the old app with a test account where available. Record entry/exit, roles, screen states, validation, offline/retry behavior, permissions, notifications, accessibility, English/Bengali copy, and sanitized API examples. Ask backend owners about stale or unused paths.

Trace each operation from api/rest/RetrofitAPI.java through its repository/presenter to the visible workflow. Record HTTP method/path, auth/headers, query/body, nullability, success/error envelope, pagination, date/timezone semantics, and write idempotency. Never invent a backend contract from the DummyJSON sample.

### 2. Bound the slice

Select one end-to-end user journey with a demonstrable finish. List shared prerequisites (session, role, navigation, location, file handling, notification), ownership, and temporary stubs. Specify offline persistence or platform bridge needs. Keep the slice independently reviewable, testable, enableable, and reversible.

### 3. Translate behavior into the existing Flutter architecture

Read [ARCHITECTURE.md](ARCHITECTURE.md), [NETWORKING.md](NETWORKING.md), [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md), and [LOCALIZATION.md](LOCALIZATION.md). Use lib/ui/<feature> for screens, widgets, view models, and actions; lib/domain for entities, repository interfaces, and tasks; lib/data for Freezed DTOs, mappers, remote sources, and implementations. Use the shared Dio ApiClient. Register implementations in lib/injection/injection.dart and route-owned Providers in lib/routes/app_pages.dart. Preserve dependency direction ui -> domain <- data. Use existing ContentState for reads and ActionState for writes. Model the Flutter domain around user operations and stable business concepts, even when Java has different presenter/repository boundaries. Do not mechanically translate Activity to screen, Presenter to view model, or each Java repository to one Dart repository; choose boundaries that fit the Flutter contracts and document the source-to-target mapping.

Use English/Bengali ARB messages and shared theme tokens. For native-only capabilities define an injected interface, Android implementation, lifecycle owner, and fake. Plan iOS separately if it is in scope. Do not copy credentials, signing files, Firebase configuration, or insecure token storage from the legacy repo.

### 4. Prove parity

Test real sanitized payload shapes with fake HTTP adapters, mapping, domain rules, view-model transitions, routes, and localized widget states. Cover relevant success, loading, empty, malformed response, timeout, 401/403, repeated taps, disposal, and retry. For writes verify double-submit protection and replay/idempotency. Manually compare the same journey in Java and Flutter on representative devices, including Bengali, larger text, dark mode, and permissions.

### 5. Pass release gates

A slice is complete when its parity checklist is signed off, API behavior is evidenced, relevant tests pass, and session/navigation/native lifecycle owners are clear. Production update additionally requires matching the intended Play app ID and signing lineage, higher version code, on-device data migration, FCM/deep-link continuity, permission/privacy review, staged rollout telemetry, and rollback. Record backend compatibility and who can disable a faulty feature.

## Module record template

Copy this section to .agents/modules/<module>.md before implementation:

~~~markdown
# <Module> migration record
Status: discovery | implementation | parity review | internal release | production
Owner: <name/team>
Legacy branch and pinned commit: <URL + SHA>
Flutter change/release: <link or version>
Release path and flag/rollback: <coexistence or replacement; mechanism>

## User journeys and parity checklist
- [ ] <Entry, happy path, exit>
- [ ] <Validation, empty/loading/error/offline states>
- [ ] <Roles, accessibility, localization, permissions>

## Source-to-target map
| Legacy Activity/Fragment/presenter/repository/API/resource | Flutter route/screen/task/repository/model | Notes |
| --- | --- | --- |

## Contract and data decisions
| Operation | Method/path | Request/auth | Success/error shape | Retry/idempotency | Evidence |
| --- | --- | --- | --- | --- | --- |

## Dependencies and unknowns
- Prerequisites:
- Native lifecycle/platform work:
- Open questions and owner:
- Intentional behavior changes, approved by:

## Evidence and exit gates
- Tests and commands:
- Manual comparison and devices:
- Security/data/upgrade review:
- Release monitoring and rollback result:
~~~

Maintain a dependency map and prioritize by business value, user frequency, dependency count, platform risk, and ability to validate. Track parity debt explicitly. Keep Java production operational until the chosen release path passes its gates.

## Current implementation placement rules

These rules supersede the older UI-action and flat-task placement statements in this document. Use the Java User app as the behavior reference and this Flutter project as the implementation architecture. Create workflow actions in `lib/domain/actions`, named `<Feature><Purpose>Action` without a `Run` or `run_` prefix, and compose their constructor-injected tasks with `TaskChain` and `runTask`. Put every feature task in `lib/domain/tasks/<feature>`. Place new raster and SVG visuals in `assets/images/` and fonts in `assets/fonts/`; do not create feature-specific asset directories.

