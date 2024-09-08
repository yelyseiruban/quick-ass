import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _isConnected = false;
  Web3App? _web3app;
  SessionData? _sessionData;

  bool get isConnected => _isConnected;
  Web3App? get web3app => _web3app;
  SessionData? get sessionData => _sessionData;

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
}