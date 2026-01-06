import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/services/firebase_auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    try {
      FirebaseAuthService.authStateChanges.listen((User? user) {
        _user = user;
        _status =
            user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
        notifyListeners();
      });
    } catch (e) {
      print('⚠️ AuthProvider: Firebase not initialized, continuing without auth: $e');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<bool> sendOTP(String phoneNumber) async {
    print('📱 AuthProvider: Starting sendOTP for $phoneNumber');
    _setLoading(true);
    _clearError();

    try {
      String formattedPhone = _formatPhoneNumber(phoneNumber);
      print('📱 AuthProvider: Formatted phone: $formattedPhone');
      bool success = await FirebaseAuthService.sendOTP(formattedPhone);

      if (success) {
        print('📱 AuthProvider: OTP sent successfully');
        _status = AuthStatus.initial;
      } else {
        print('📱 AuthProvider: Failed to send OTP');
        _setError('Failed to send OTP');
      }

      _setLoading(false);
      return success;
    } catch (e) {
      print('📱 AuthProvider: Exception in sendOTP - $e');
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyOTP(String otp) async {
    print('📱 AuthProvider: Starting verifyOTP for: $otp');
    _setLoading(true);
    _clearError();

    try {
      UserCredential? result = await FirebaseAuthService.verifyOTP(otp);

      // Handle test mode (result will be null for test phone number)
      if (result != null || FirebaseAuthService.verificationId == 'test_verification_id') {
        print('📱 AuthProvider: OTP verified successfully');
        _user = result?.user;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        return true;
      } else {
        print('📱 AuthProvider: OTP verification failed - result is null');
        _setError('Invalid OTP');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('📱 AuthProvider: Exception in verifyOTP - $e');
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword(String phoneNumber) async {
    _setLoading(true);
    _clearError();

    try {
      String formattedPhone = _formatPhoneNumber(phoneNumber);
      bool success = await FirebaseAuthService.resetPassword(formattedPhone);

      if (!success) {
        _setError('Failed to send reset OTP');
      }

      _setLoading(false);
      return success;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);

    try {
      await FirebaseAuthService.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _setError(_getErrorMessage(e));
    }

    _setLoading(false);
  }

  String _formatPhoneNumber(String phoneNumber) {
    print('📱 AuthProvider: Formatting phone number: $phoneNumber');
    
    // Handle test phone number
    if (phoneNumber == '7405152969' || phoneNumber == '+917405152969') {
      print('🧪 AuthProvider: Using test phone number');
      return '+917405152969';
    }
    
    // If already starts with +91, use as is
    if (phoneNumber.startsWith('+91')) {
      print('📱 AuthProvider: Phone already formatted: $phoneNumber');
      return phoneNumber;
    }
    
    // Remove any non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    print('📱 AuthProvider: Cleaned phone: $cleaned');

    // Add country code if not present
    if (!cleaned.startsWith('91')) {
      cleaned = '91$cleaned';
    }

    String formatted = '+$cleaned';
    print('📱 AuthProvider: Final formatted phone: $formatted');
    return formatted;
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          return 'Invalid phone number format';
        case 'too-many-requests':
          return 'Too many requests. Please try again later';
        case 'invalid-verification-code':
          return 'Invalid OTP code';
        case 'session-expired':
          return 'OTP session expired. Please request a new one';
        default:
          return error.message ?? 'Authentication error occurred';
      }
    }
    return error.toString();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _status = AuthStatus.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.initial;
    }
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
