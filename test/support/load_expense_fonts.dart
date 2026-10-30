import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

Future<void> loadExpenseFonts() async {
  final fonts = path.normalize(
    path.join(
      path.dirname(Platform.resolvedExecutable),
      '..',
      '..',
      'material_fonts',
    ),
  );
  final roboto = FontLoader('Roboto');
  for (final name in ['roboto-regular.ttf', 'roboto-bold.ttf']) {
    final bytes = await File(path.join(fonts, name)).readAsBytes();
    roboto.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons');
  final bytes = await File(path.join(fonts, 'materialicons-regular.otf'))
      .readAsBytes();
  icons.addFont(Future.value(ByteData.sublistView(bytes)));
  await icons.load();
}
