import 'package:package_info_plus/package_info_plus.dart';

class AppPackageMetadata {
  const AppPackageMetadata({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
}

abstract interface class AppPackageInfo {
  Future<AppPackageMetadata> load();
}

class PlatformAppPackageInfo implements AppPackageInfo {
  @override
  Future<AppPackageMetadata> load() async {
    final info = await PackageInfo.fromPlatform();
    return AppPackageMetadata(
      appName: info.appName,
      packageName: info.packageName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }
}
