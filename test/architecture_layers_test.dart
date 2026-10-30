import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Iterable<File> dartFiles(String path) => Directory(path)
    .listSync(recursive: true)
    .whereType<File>()
    .where((file) => file.path.endsWith('.dart'));

String normalizedPath(File file) => file.path.replaceAll(r'\', '/');

void main() {
  test('domain remains independent from data and UI', () {
    for (final file in dartFiles('lib/domain')) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(matches(RegExp(r'''import\s+['"][^'"]*(?:data|ui)/'''))),
        reason: '${normalizedPath(file)} crosses the domain boundary',
      );
    }
  });

  test('UI does not import concrete data-layer types', () {
    for (final file in dartFiles('lib/ui')) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(
          matches(
            RegExp(
              r'''import\s+['"][^'"]*data/(?:datasources|mappers|models|repositories)/''',
            ),
          ),
        ),
        reason: '${normalizedPath(file)} bypasses the domain layer',
      );
    }
  });

  test('remote data sources have one canonical location', () {
    final offenders = <String>[];
    for (final file in dartFiles('lib')) {
      if (!file.readAsStringSync().contains('extends BaseRemoteDataSource')) {
        continue;
      }
      final path = normalizedPath(file);
      if (!path.startsWith('lib/data/datasources/remote/')) {
        offenders.add(path);
      }
    }
    expect(offenders, isEmpty);
  });

  test('data DTOs use Freezed and generated JSON serialization', () {
    for (final file in dartFiles(
      'lib/data/models',
    ).where((file) => normalizedPath(file).endsWith('_model.dart'))) {
      final source = file.readAsStringSync();
      expect(
        source,
        contains('@freezed'),
        reason: '${normalizedPath(file)} is not a Freezed DTO',
      );
      expect(
        source,
        contains(
          "part '${file.uri.pathSegments.last.replaceFirst('.dart', '.freezed.dart')}';",
        ),
        reason: '${normalizedPath(file)} is missing its Freezed part',
      );
      expect(
        source,
        contains(
          "part '${file.uri.pathSegments.last.replaceFirst('.dart', '.g.dart')}';",
        ),
        reason: '${normalizedPath(file)} is missing its JSON part',
      );
      expect(
        source,
        contains('fromJson(Map<String, dynamic> json)'),
        reason: '${normalizedPath(file)} is missing generated JSON factories',
      );
    }
  });
}
