import 'package:flutter/foundation.dart';

class LoginProvider with ChangeNotifier {
  String _number = '';
  String _password = '';

  String get number => _number;
  String get password => _password;

  void updateNumber(String value) {
    _number = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }
}
