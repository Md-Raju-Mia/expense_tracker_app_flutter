import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

enum AppImageSource { camera, gallery }

abstract interface class AppPickedImage {
  String get path;
  String get name;
  String? get mimeType;
  Future<int> length();
  Future<Uint8List> readAsBytes();
}

class _PlatformPickedImage implements AppPickedImage {
  const _PlatformPickedImage(this._file);

  final XFile _file;

  @override
  String get path => _file.path;

  @override
  String get name => _file.name;

  @override
  String? get mimeType => _file.mimeType;

  @override
  Future<int> length() => _file.length();

  @override
  Future<Uint8List> readAsBytes() => _file.readAsBytes();
}

class AppImagePickerException implements Exception {
  const AppImagePickerException(this.code, this.message);

  final String code;
  final String? message;

  @override
  String toString() => 'AppImagePickerException($code): $message';
}

abstract interface class AppImagePicker {
  Future<AppPickedImage?> pick({
    required AppImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  });

  /// Recovers images after Android destroys the picker activity.
  Future<List<AppPickedImage>> recoverLostImages();
}

class PlatformAppImagePicker implements AppImagePicker {
  PlatformAppImagePicker([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<AppPickedImage?> pick({
    required AppImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final file = await _picker.pickImage(
      source: switch (source) {
        AppImageSource.camera => ImageSource.camera,
        AppImageSource.gallery => ImageSource.gallery,
      },
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    return file == null ? null : _PlatformPickedImage(file);
  }

  @override
  Future<List<AppPickedImage>> recoverLostImages() async {
    final response = await _picker.retrieveLostData();
    final exception = response.exception;
    if (exception != null) {
      throw AppImagePickerException(exception.code, exception.message);
    }
    return (response.files ?? const []).map(_PlatformPickedImage.new).toList();
  }
}
