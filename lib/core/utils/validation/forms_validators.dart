typedef AppFieldValidator = String? Function(String? value);

/// Small composable form validators.
///
/// Callers supply localized messages so this utility remains independent of
/// BuildContext and the active locale.
abstract final class FormsValidators {
  static AppFieldValidator required({required String message}) => (value) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  };

  static AppFieldValidator email({required String message}) {
    final pattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return (value) {
      final normalized = value?.trim() ?? '';
      if (normalized.isEmpty) return null;
      return pattern.hasMatch(normalized) ? null : message;
    };
  }

  static AppFieldValidator phone({required String message}) {
    final pattern = RegExp(r'^\+?[0-9]{7,15}$');
    return (value) {
      final normalized = (value ?? '').replaceAll(RegExp(r'[\s\-()]'), '');
      if (normalized.isEmpty) return null;
      return pattern.hasMatch(normalized) ? null : message;
    };
  }

  static AppFieldValidator minLength(int length, {required String message}) {
    assert(length >= 0);
    return (value) {
      final normalized = value?.trim() ?? '';
      if (normalized.isEmpty) return null;
      return normalized.length < length ? message : null;
    };
  }

  static AppFieldValidator maxLength(int length, {required String message}) {
    assert(length >= 0);
    return (value) {
      final normalized = value?.trim() ?? '';
      if (normalized.isEmpty) return null;
      return normalized.length > length ? message : null;
    };
  }

  static AppFieldValidator optional(AppFieldValidator validator) => (value) {
    if (value == null || value.trim().isEmpty) return null;
    return validator(value);
  };

  static AppFieldValidator combine(Iterable<AppFieldValidator> validators) =>
      (value) {
        for (final validator in validators) {
          final result = validator(value);
          if (result != null) return result;
        }
        return null;
      };
}
