import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _isConnected = false;
  Web3App? _web3app;
  SessionData? _sessionData;
  String _statusString = '';

  bool get isConnected => _isConnected;
  Web3App? get web3app => _web3app;
  SessionData? get sessionData => _sessionData;
  String get statusString => _statusString;

  void setConnection(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  void setSessionData(SessionData? sessionData) {
    _sessionData = sessionData;
    notifyListeners();
  }
  void setWeb3App(Web3App web3app) {
    _web3app = web3app;
    notifyListeners();
  }

  void setStatusString(String status) {
    _statusString = status;
    log(status);
    notifyListeners();
  }
}