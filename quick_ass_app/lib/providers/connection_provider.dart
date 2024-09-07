import 'package:flutter/material.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void setConnection(bool value) {
    _isConnected = value;
    notifyListeners();
  }
}