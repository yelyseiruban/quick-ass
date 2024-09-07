import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Package {
  factory Package() => _instance;

  Package._internal();

  static final Package _instance = Package._internal();

  PackageInfo? _info;

  PackageInfo get info => _info!;

  Future<void> init() async {
    _info = await PackageInfo.fromPlatform();
  }

  Future<bool> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? version = prefs.getString('version');

    if (version != _info!.version) {
      await prefs.setString('version', _info!.version);
    }
    return true;
  }
}
