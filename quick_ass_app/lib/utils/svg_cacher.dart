import 'package:flutter_svg/flutter_svg.dart';

class SvgCache {
  Future<void> cacheIcons() async {
    for (String iconPath in _svgList) {
      var loader = SvgAssetLoader(iconPath);
      await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }

  final List<String> _svgList = [
    'assets/icons/rabbit.svg',
  ];
}