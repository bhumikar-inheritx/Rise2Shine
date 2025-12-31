import '../../core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import '../utils/toast_util.dart';
import '../constants/text_constants.dart';

enum ViewState { idle, loading, error, success }

class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;
  bool _isButtonLoading = false; // Track button loading state

  ViewState get state => _state;

  String? get errorMessage => _errorMessage;

  bool get isButtonLoading => _isButtonLoading;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    _state = ViewState.error;
    ToastUtils.showError(message);
    notifyListeners();
  }

  //  Button Loading State Management
  void startButtonLoading() {
    _isButtonLoading = true;
    notifyListeners();
  }

  void stopButtonLoading() {
    _isButtonLoading = false;
    notifyListeners();
  }

  Future<T?> callFirebaseOperation<T>(
    Future<T> Function() operation, {
    bool useButtonLoading = false,
  }) async {
    try {
      setState(ViewState.loading);
      final result = await operation();
      setState(ViewState.success);
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }

  // Generic method to execute a task after a delay.
  Future<void> postDelayed(
      {required int milliseconds, required VoidCallback task}) async {
    await Future.delayed(Duration(milliseconds: milliseconds), task);
  }

  // Safe navigation method from provider
  void navigateTo(BuildContext ctx, String route, {Object? arguments}) {
    NavigationService(ctx).navigateTo(route, arguments: arguments);
  }

  // Safe navigation method from provider
  void replaceTo(BuildContext ctx, String route, {Object? arguments}) {
    NavigationService(ctx).replaceTo(route, arguments: arguments);
  }
}
