import 'package:flutter/widgets.dart';

class PasswordProvider with ChangeNotifier {
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  bool get isObscure {
    return _isObscure;
  }

  bool get isConfirmObscure {
    return _isConfirmObscure;
  }

  void toggleIsObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void toggleIsConfirmObscure() {
    _isConfirmObscure = !_isConfirmObscure;
    notifyListeners();
  }
}