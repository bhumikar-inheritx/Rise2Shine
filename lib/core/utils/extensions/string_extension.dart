extension StringExtension on String {
  String get capitalize =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isValidPassword =>
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(this);

  String toTitleCase() => split(' ').map((str) => str.capitalize).join(' ');
}

extension StringValidatorExtension on String? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
}
