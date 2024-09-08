import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/routes/index.dart';
import 'package:quick_ass_app/wallet/send-eth/index.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UsersConnectionProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool _isSocketConnected = false;
  String _statusString = '';
  Map<String, dynamic>? _closestDevice;
  bool _isUsersConnectionEstablished = false;

  bool get isConnected => _isSocketConnected;
  String get statusString => _statusString;
  Map<String, dynamic>? get closestDevice => _closestDevice;
  bool get isUsersConnectionEstablished => _isUsersConnectionEstablished;

  void connectToSocket() {
    final url = 'ws://192.168.28.42:8080';
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _isSocketConnected = true;
    _statusString = 'Connected to $url';
    notifyListeners();

    _channel!.stream.listen(
      (message) {
        _handleMessage(message);
      },
      onDone: () {
        _isSocketConnected = false;
        _statusString = 'Disconnected';
        notifyListeners();
      },
      onError: (error) {
        _isSocketConnected = false;
        _statusString = 'Connection error: $error';
        notifyListeners();
      },
    );
  }

  void _handleMessage(String message) {
    try {
      final data = jsonDecode(message);
      if (data.containsKey('closestDevice')) {
        _closestDevice = data['closestDevice'];
        _statusString = 'Closest device found';
      } else if (data.containsKey('error')) {
        _statusString = 'Error: ${data['error']}';
      }
      if (navigatorKey.currentState != null && _isUsersConnectionEstablished == false) {
        final context = navigatorKey.currentState!.context;
        showModalBottomSheet(context: context, builder: (context) {
          return SendEthSheet();
        });
        _isUsersConnectionEstablished = true;
      } else {
        Fluttertoast.showToast(
          msg: "Actually we don't know what's gone wrong, try one more time, check connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 14.0,
        );
      }
      notifyListeners();
    } catch (error) {
      log('Error handling message: $error');
    }
  }

  void sendLocationData(Position position, String ethAddress) {
    final lat = position.latitude;
    final lng = position.longitude;
    if (_channel != null && _isSocketConnected) {
      final data = jsonEncode({
        'lat': lat,
        'lng': lng,
        'ethAddress': ethAddress,
      });
      log(data.toString());
      _channel!.sink.add(data);
      _statusString = 'Location data sent';
      notifyListeners();
    } else {
      _statusString = 'Not connected';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}