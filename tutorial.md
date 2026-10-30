# Tutorial: convert one local Java file to Flutter

Give the coding agent only a Java filename from the local [UserAppJava](UserAppJava) source directory, for example `LoginActivity.java`. The agent owns the investigation and conversion: it locates the file, pins the local Java Git revision, traces its complete behavior and dependencies, creates the migration record and Flutter folders, writes the Flutter code, and proves parity. You do not need to provide a source path, Git SHA, API details, folder plan, or record.

Conversion happens in this existing Flutter project. `UserAppJava` supplies the UI and behavior contract; [.agents/ARCHITECTURE.md](.agents/ARCHITECTURE.md) supplies the mandatory Flutter code structure. Use this project's Provider MVVM, go_router, get_it, and UI/domain/data layers. Do not copy Java Activities, MVP presenters, or repository wiring one-to-one into Dart. Preserve current Java UI and behavior exactly, including bugs. No bug fixes, UI improvements, new features, or changed flows belong in a conversion task.

## Copy-paste command

Replace only the bracketed Java filename:

~~~text
Convert the feature represented by [Java filename] from the local
UserAppJava source directory to Flutter in this existing project.
Locate the file yourself and pin the local Java Git revision. Trace
its callers, entry and exit flow, related Activities/Fragments,
presenters/tasks, repositories, APIs, models, layouts, resources,
and relevant storage or native behavior. Create the migration record
and necessary Flutter folders, implement the complete behavior using
this project's Flutter architecture (not the Java architecture), and
verify exact Java-to-Flutter UI and behavior parity. Preserve existing
bugs. Do not fix, redesign, simplify, or add behavior. Do not ask me
for a SHA, source path, API details, or a record.
~~~

For example: **“Convert `LoginActivity.java` from the local UserAppJava source to Flutter. Keep its Java UI and logic exactly.”** A filename is enough; the agent finds the matching file and all required dependencies. If the filename exists in more than one Java package and the intended source cannot be inferred, the agent may ask which path is intended. It should not turn routine source discovery into questions for you.

## What the agent must do after receiving that command

The following is the **agent's work**, not homework for you:

1. Read [.agents/AGENTS.md](.agents/AGENTS.md), [.agents/MEMORY.md](.agents/MEMORY.md), and [.agents/MIGRATION.md](.agents/MIGRATION.md). Inspect this Flutter repository and the local [UserAppJava](UserAppJava) checkout. Record its exact Git revision. If the directory or named file cannot be accessed, report that concrete blocker; do not invent behavior.
2. Locate the named Java file with searches. Trace its callers and exit flow, Activity/Fragment, presenter/task, repository, Retrofit declaration, models, XML, strings/assets, and any Room, preferences, service, receiver, permission, or notification dependency. Observe the installed Java app with test data when available. Source code alone may not prove current production behavior. Put any conversion-created SVG or image in the existing `assets/images/` directory, without creating feature-specific asset folders; font files belong in `assets/fonts/`.
3. Copy the module-record template in [.agents/MIGRATION.md](.agents/MIGRATION.md) to `.agents/modules/<feature>.md`. Fill in the revision, exact requested boundary, source-to-target map, UI and logic evidence, API contract, test scenarios, and unknowns. Create the Flutter folders and files needed for that boundary.
4. Implement with this project's Flutter architecture: go_router routes, route-owned Provider view models, get_it composition, UI/domain/data separation, domain actions in `lib/domain/actions`, feature tasks in `lib/domain/tasks/<feature>`, repository contracts, data sources, and localization. Never create actions under `lib/ui` or feature tasks directly under `lib/domain/tasks`. Name actions without a `Run`/`run_` prefix; inject their tasks and coordinate them with `TaskChain` and `runTask`. The Java classes are discovery evidence, not Dart class templates. Match Java screens, colors, icons, copy, navigation, validation, timing, error states, request/response behavior, offline persistence, and platform effects. Existing Java defects stay as they are.
5. Generate code where needed; run targeted tests, analysis, and the full test suite when shared code changes. Compare the same scenarios in Java and Flutter on Android. Keep every mismatch open in the module record and continue until the requested scope matches.
6. Report what was converted, which local Java revision was used, the files/record created, tests and parity evidence, and any remaining blocker. The requested Java file's complete user-visible behavior and necessary dependencies must be converted; do not label an incomplete slice “done.”

Your review question is simple: **“Does the Flutter feature derived from this Java file look and behave exactly like the Java app for the same scenario?”** If the answer is no, give the agent the observed difference; it should resolve it as part of conversion, not treat it as a new bug-fix request.