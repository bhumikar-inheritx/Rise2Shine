class TextConstants {
  // Auth Screen Texts
  static const login = 'Login';
  static const register = 'Register';
  static const email = 'Email';
  static const password = 'Password';

  // HTTP Status Code Messages
  static const badRequest =
      'Please check the information you\'ve entered and try again';
  static const unauthorized = 'Your session has expired. Please log in again';
  static const forbidden = 'You don\'t have permission to access this feature';
  static const notFound = 'The requested information could not be found';
  static const methodNotAllowed = 'This action is not supported at the moment';
  static const conflict =
      'This action cannot be completed due to a conflict with existing data';
  static const tooManyRequests =
      'Too many attempts. Please try again in a few minutes';
  static const internalServer =
      'We\'re experiencing technical difficulties. Please try again later';
  static const serviceUnavailable =
      'Our service is temporarily down for maintenance. Please try again later';

  // Connection Messages
  static const generalError = 'Something went wrong. Please try again';
  static const timeoutError =
      'The request is taking too long. Please check your connection and try again';
  static const internetError =
      'Please check your internet connection and try again';
  static const serverError =
      'We\'re having trouble connecting to our servers. Please try again later';
  static const unexpectedError =
      'Something unexpected happened. Please try again';

  // Optional: Business-specific messages for common scenarios
  static const dataValidationError =
      'Some of the information you entered isn\'t quite right. Please review and try again';
  static const accountLocked =
      'Your account has been temporarily locked for security. Please contact support';
  static const maintenanceMode =
      'We\'re currently updating our system to serve you better. Please try again in a few minutes';
  static const paymentRequired =
      'There seems to be an issue with your subscription. Please check your payment details';

  // Validation Messaged
  static const invalidEmail = 'Please enter a valid email';
  static const invalidPassword = 'Password must be at least 6 characters';
  static const onlyAlphaNumericAllowed = 'Only alpha numeric value allowed';
  static const enterValidMobileNumber = 'Enter a valid mobile number';
  static const fullNameRequired = 'Full name is required';
  static const phoneNumberRequired = 'Phone number is required';

  // Success Messages
  static const loginSuccess = 'Login successful';
  static const registerSuccess = 'Registration successful';

  // Button Texts
  static const submit = 'Submit';
  static const cancel = 'Cancel';
  static const retry = 'Retry';
  static const ok = 'OK';
  static const chooseProfile = 'Choose profile';

  // Profile Selection Texts
  static const iAmAParent = 'I am a parent';
  static const iAmAChild = 'I am a child';

  // Signup Texts
  static const fullName = 'Full name';
  static const phoneNumber = 'Phone number';
  static const enterFullName = 'Enter full name';
  static const enterPhoneNumber = 'Enter phone number';
  static const phoneCode = '+91';
  static const verifyOtp = 'Verify OTP';
  static const enterOtp = 'Enter OTP';
  static const resendOtp = 'Resend OTP';
  static const verify = 'Verify';
  static const setPasscode = 'Set passcode';
  static const confirmPasscode = 'Confirm passcode';
  static const forgotPasscode = 'Forgot passcode?';
  static const pleaseEnterCompleteOtp = 'Please enter complete OTP';
  static const invalidOtpTryAgain = 'Invalid OTP. Please try again';
  static const passwordsDoNotMatch = 'Passwords do not match';
  static const passcodeWrong = 'Passcode is wrong';
  static const enterPasscode = 'Enter passcode';
  
  // Add Child Screen Texts
  static const addYourChild = 'Add your child';
  static const chooseAvatar = 'Choose avatar';
  static const childName = 'Child name';
  static const enterChildName = 'Enter child name';
  static const dateOfBirth = 'Date of birth';
  static const selectDateOfBirth = 'Select date of birth';
  static const setChildPasscode = 'Set child passcode';
  static const addChild = 'Add child';
  
  // Home Screen Texts
  static const addChilds = 'Add Child(s)';
  static const homeContent = 'Start with adding your child and give them task to earn reward';
  static const addNewTask = 'Add new task';

  // Bottom Navigation Labels
  static const home = 'Home';
  static const task = 'Task';
  static const rewards = 'Rewards';
  static const stats = 'Stats';
  static const more = 'More';
}
