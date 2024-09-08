import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalNavigation {
  factory ExternalNavigation() => _instance;

  ExternalNavigation._internal();

  static final ExternalNavigation _instance = ExternalNavigation._internal();
  final InAppBrowser browser = InAppBrowser();

  Future<void> popupUri(WebUri uri) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return browser.openUrlRequest(
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
            )),
        crossPlatform: InAppBrowserOptions(
          hideToolbarTop: true,
          toolbarTopBackgroundColor:
          isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
        ),
        ios: IOSInAppBrowserOptions(
          presentationStyle: IOSUIModalPresentationStyle.POPOVER,
          hideToolbarBottom: true,
        ),
      ),
      urlRequest: URLRequest(url: uri),
    );
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  Future<void> bottomSheet(BuildContext context, WidgetBuilder builder) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: builder);
  }
}
