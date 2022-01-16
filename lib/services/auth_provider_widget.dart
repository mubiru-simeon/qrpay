import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthProvider extends InheritedWidget {
  final AuthService auth;
  AuthProvider({
    Key key,
    Widget child,
    this.auth,
  }) : super(key: key, child: child);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(InheritedWidget oldWiddget) {
    return true;
  }

  static AuthProvider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<AuthProvider>());
}