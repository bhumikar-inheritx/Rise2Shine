import '../constants/text_constants.dart';

class ValidationUtils {
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final alphaNumericRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (!alphaNumericRegex.hasMatch(value)) {
      return TextConstants.onlyAlphaNumericAllowed;
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return TextConstants.enterValidMobileNumber;
    }
    return null;
  }
}