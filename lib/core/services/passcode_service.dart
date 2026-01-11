import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasscodeService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _keyPasscodeHash = 'passcode_hash';
  static const String _keyPasscodeSession = 'passcode_session';
  static const String _keyIsPasscodeSet = 'is_passcode_set';

  // Hash passcode using SHA-256
  static String _hashPasscode(String passcode) {
    final bytes = utf8.encode(passcode);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Save passcode hash
  static Future<bool> savePasscode(String passcode) async {
    try {
      final hash = _hashPasscode(passcode);
      await _storage.write(key: _keyPasscodeHash, value: hash);
      await _storage.write(key: _keyIsPasscodeSet, value: 'true');
      print('✅ PasscodeService: Passcode saved successfully');
      return true;
    } catch (e) {
      print('❌ PasscodeService: Error saving passcode - $e');
      return false;
    }
  }

  // Verify passcode
  static Future<bool> verifyPasscode(String passcode) async {
    try {
      final savedHash = await _storage.read(key: _keyPasscodeHash);
      if (savedHash == null) {
        return false;
      }
      final inputHash = _hashPasscode(passcode);
      return savedHash == inputHash;
    } catch (e) {
      print('❌ PasscodeService: Error verifying passcode - $e');
      return false;
    }
  }

  // Check if passcode is set
  static Future<bool> isPasscodeSet() async {
    try {
      final isSet = await _storage.read(key: _keyIsPasscodeSet);
      return isSet == 'true';
    } catch (e) {
      print('❌ PasscodeService: Error checking passcode status - $e');
      return false;
    }
  }

  // Create passcode session (after successful verification)
  static Future<bool> createSession() async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      await _storage.write(key: _keyPasscodeSession, value: timestamp);
      print('✅ PasscodeService: Session created');
      return true;
    } catch (e) {
      print('❌ PasscodeService: Error creating session - $e');
      return false;
    }
  }

  // Check if session is valid (within last 24 hours)
  static Future<bool> isSessionValid() async {
    try {
      final sessionTimestamp = await _storage.read(key: _keyPasscodeSession);
      if (sessionTimestamp == null) {
        return false;
      }
      final sessionTime = DateTime.parse(sessionTimestamp);
      final now = DateTime.now();
      final difference = now.difference(sessionTime);
      // Session valid for 24 hours
      return difference.inHours < 24;
    } catch (e) {
      print('❌ PasscodeService: Error checking session - $e');
      return false;
    }
  }

  // Clear passcode and session (on logout)
  static Future<bool> clearPasscode() async {
    try {
      await _storage.delete(key: _keyPasscodeHash);
      await _storage.delete(key: _keyPasscodeSession);
      await _storage.delete(key: _keyIsPasscodeSet);
      print('✅ PasscodeService: Passcode cleared');
      return true;
    } catch (e) {
      print('❌ PasscodeService: Error clearing passcode - $e');
      return false;
    }
  }

  // Clear session only (keep passcode)
  static Future<bool> clearSession() async {
    try {
      await _storage.delete(key: _keyPasscodeSession);
      print('✅ PasscodeService: Session cleared');
      return true;
    } catch (e) {
      print('❌ PasscodeService: Error clearing session - $e');
      return false;
    }
  }
}
