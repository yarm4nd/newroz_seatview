/// Form field validators.
class Validators {
  const Validators._();

  static final RegExp _phone = RegExp(r'^\+?\d{10,14}$');

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your full name';
    if (text.length < 3) return 'Name is too short';
    return null;
  }

  static String? phone(String? value) {
    final text = (value ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (text.isEmpty) return 'Please enter your phone number';
    if (!_phone.hasMatch(text)) return 'Enter a valid phone number';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Please enter a password';
    if (text.length < 6) return 'Use at least 6 characters';
    return null;
  }

  /// Checks that the field matches the password typed before it.
  static String? Function(String?) confirmPassword(
    String Function() original,
  ) {
    return (value) =>
        (value ?? '') == original() ? null : 'Passwords do not match';
  }
}
