import java.util.Base64

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val adMobAppId = providers.gradleProperty("dart-defines").orNull
    ?.split(',')
    ?.map { String(Base64.getDecoder().decode(it), Charsets.UTF_8) }
    ?.lastOrNull { it.startsWith("ADMOB_ANDROID_APP_ID=") }
    ?.substringAfter('=')
    ?.takeIf { it.matches(Regex("ca-app-pub-[0-9]{16}~[0-9]{10}")) }
    ?: "ca-app-pub-3940256099942544~3347511713"

android {
    namespace = "com.example.expense_tracker_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        manifestPlaceholders["adMobAppId"] = "ca-app-pub-3940256099942544~3347511713"
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.expense_tracker_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            manifestPlaceholders["adMobAppId"] = adMobAppId
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
