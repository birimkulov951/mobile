import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class UrlLauncher {
  UrlLauncher._();

  static Future<bool> canLaunchUrl(String url) async {
    final uri = Uri.parse(url);
    return await urlLauncher.canLaunchUrl(uri);
  }

  static Future<void> launchUrl(
    String url, {
    urlLauncher.LaunchMode mode = urlLauncher.LaunchMode.platformDefault,
  }) async {
    final _uri = Uri.parse(url);
    if (await urlLauncher.canLaunchUrl(_uri)) {
      await urlLauncher.launchUrl(_uri, mode: mode);
    }
  }
}
