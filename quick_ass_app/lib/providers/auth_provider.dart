import 'package:flutter/foundation.dart';
import 'package:quick_ass_app/sqlite/user_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  late String _currentUserId = '';
  late bool _isLoading = false;
  String _nickname = "";
  String _password = "";
  String _newPassword = "";
  String _id = "";
  String? _token;

  // Getters
  String get nickname => _nickname;
  String get password => _password;
  String get newPassword => _newPassword;
  String get id => _id;
  String? get token => _token;

  bool get isLoading => _isLoading;
  String get currentUserId => _currentUserId;
  late bool _showPassword = false;
  bool get showPassword => _showPassword;

  // Setters
  void setPasswordVisible(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  void setNickname(String value) {
    _nickname = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setNewPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  void setId(String value) {
    _id = value;
    notifyListeners();
  }

  void setToken(String? value) {
    _token = value;
    notifyListeners();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<bool> signIn() async {
    try {
      final user = await UserDatabaseHelper.signIn(_nickname, _password);

      Object? id = user[0]['id'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', "$id");
      return user.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp() async {
    final currentTime = DateTime.now().microsecondsSinceEpoch;
    final user = {
      'nickname': nickname,
      'password': password,
      'createdAt': currentTime,
      'updatedAt': currentTime
    };
    try {
      await UserDatabaseHelper.createItem(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<bool> authentiacted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    _currentUserId = token;
    return token.isNotEmpty;
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    _currentUserId = token;
    return token;
  }

  Future<bool> changePassword() async {
    try {
      final user = await UserDatabaseHelper.signIn(nickname, _password);

      Object? userId = user[0]['id'];
      if (user.isNotEmpty) {
        try {
          await UserDatabaseHelper.updateUser(
              int.parse("$userId"), _newPassword);
          return true;
        } catch (e) {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
