import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/logger.dart';

class FirebaseAuthService {
  static FirebaseAuth? _auth;
  static String? _verificationId;
  
  // Test phone number configuration
  static const String _testPhoneNumber = '+917405152969';
  static const String _testOtp = '000000';
  
  // Getter for verification ID (for test mode check)
  static String? get verificationId => _verificationId;

  static FirebaseAuth? get _firebaseAuth {
    try {
      _auth ??= FirebaseAuth.instance;
      return _auth;
    } catch (e) {
      print('⚠️ FirebaseAuthService: Firebase not initialized: $e');
      return null;
    }
  }

  static User? get currentUser => _firebaseAuth?.currentUser;
  static Stream<User?> get authStateChanges {
    try {
      return _firebaseAuth?.authStateChanges() ?? Stream.value(null);
    } catch (e) {
      print('⚠️ FirebaseAuthService: Error getting auth state changes: $e');
      return Stream.value(null);
    }
  }

  static Future<bool> sendOTP(String phoneNumber) async {
    try {
      final auth = _firebaseAuth;
      if (auth == null) {
        print('⚠️ Firebase: Firebase Auth not available');
        return false;
      }
      
      print('🔥 Firebase: Sending OTP to $phoneNumber');
      
      // Handle test phone number
      if (phoneNumber == _testPhoneNumber) {
        print('🧪 Firebase: Using test phone number - OTP will be $_testOtp');
        _verificationId = 'test_verification_id';
        return true;
      }
      
      // Use Completer to handle async callbacks
      final completer = Completer<bool>();
      
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('🔥 Firebase: Auto verification completed');
          try {
            await auth.signInWithCredential(credential);
            if (!completer.isCompleted) completer.complete(true);
          } catch (e) {
            print('🔥 Firebase: Auto sign-in failed: $e');
            if (!completer.isCompleted) completer.complete(false);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('🔥 Firebase: Verification failed - ${e.code}: ${e.message}');
          if (!completer.isCompleted) completer.completeError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          print('🔥 Firebase: OTP sent successfully. VerificationId: $verificationId');
          if (!completer.isCompleted) completer.complete(true);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print('🔥 Firebase: Auto retrieval timeout. VerificationId: $verificationId');
        },
        timeout: const Duration(seconds: 60),
      );
      
      return await completer.future;
    } catch (e) {
      print('🔥 Firebase: Error sending OTP - $e');
      return false;
    }
  }

  static Future<UserCredential?> verifyOTP(String otp) async {
    try {
      final auth = _firebaseAuth;
      if (auth == null) {
        print('⚠️ Firebase: Firebase Auth not available');
        return null;
      }
      
      print('🔥 Firebase: Verifying OTP: $otp');
      if (_verificationId == null) {
        print('🔥 Firebase: ERROR - Verification ID is null');
        throw Exception('Verification ID not found');
      }
      
      // Handle test OTP
      if (_verificationId == 'test_verification_id') {
        if (otp == _testOtp) {
          print('🧪 Firebase: Test OTP verified successfully');
          // For test mode, we'll simulate success without actual credential
          return null; // AuthProvider will handle this as success
        } else {
          print('🧪 Firebase: Invalid test OTP');
          throw FirebaseAuthException(
            code: 'invalid-verification-code',
            message: 'Invalid OTP code',
          );
        }
      }
      
      print('🔥 Firebase: Using verificationId: $_verificationId');
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      
      print('🔥 Firebase: Signing in with credential...');
      UserCredential result = await auth.signInWithCredential(credential);
      print('🔥 Firebase: User signed in successfully - UID: ${result.user?.uid}');
      return result;
    } catch (e) {
      print('🔥 Firebase: Error verifying OTP - $e');
      throw e;
    }
  }

  static Future<void> signOut() async {
    try {
      final auth = _firebaseAuth;
      if (auth == null) {
        print('⚠️ Firebase: Firebase Auth not available');
        return;
      }
      
      print('🔥 Firebase: Signing out user');
      await auth.signOut();
      print('🔥 Firebase: User signed out successfully');
    } catch (e) {
      print('🔥 Firebase: Error signing out - $e');
      throw e;
    }
  }

  static Future<bool> resetPassword(String phoneNumber) async {
    try {
      print('🔥 Firebase: Resetting password for $phoneNumber');
      return await sendOTP(phoneNumber);
    } catch (e) {
      print('🔥 Firebase: Error resetting password - $e');
      return false;
    }
  }
}