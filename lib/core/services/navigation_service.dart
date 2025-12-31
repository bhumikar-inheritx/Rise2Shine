import 'package:flutter/material.dart';

class NavigationService {
  final BuildContext ctx;

  NavigationService(this.ctx);

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return Navigator.of(ctx).pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> replaceTo(String routeName, {Object? arguments}) {
    return Navigator.of(ctx).pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateToAndRemoveUntil(String routeName,
      {Object? arguments}) {
    return Navigator.of(ctx).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  void goBack() {
    return Navigator.of(ctx).pop();
  }
}
