import 'dart:io';

class CustomProxy {
  String ipAddress;
  int? port;
  bool allowBadCertificates;
  bool isEnabled = false;

  CustomProxy({
    required this.ipAddress,
    this.port,
    this.allowBadCertificates = false,
  });

  static CustomProxy? fromString({String? proxy}) {
    if (proxy == null || proxy == "") {
      assert(
          false, "Proxy string passed to CustomProxy.fromString() is invalid.");
      return null;
    }

    final proxyParts = proxy.split(":");
    final _ipAddress = proxyParts[0];
    final _port = proxyParts.length > 0 ? int.tryParse(proxyParts[1]) : null;
    return CustomProxy(
      ipAddress: _ipAddress,
      port: _port,
    );
  }

  void enable() {
    HttpOverrides.global =
        new CustomProxyHttpOverride.withProxy(this.toString());
    isEnabled = true;
  }

  void disable() {
    HttpOverrides.global = null;
    isEnabled = false;
  }

  bool isProxyEnabled() {
    return isEnabled;
  }

  void setIpAddress(String ipAddress) {
    this.ipAddress = ipAddress;
  }

  void setPort(int port) {
    this.port = port;
  }

  @override
  String toString() {
    String _proxy = this.ipAddress;
    if (this.port != null) {
      _proxy += ":" + this.port.toString();
    }
    return _proxy;
  }
}

class CustomProxyHttpOverride extends HttpOverrides {
  final String? proxyString;
  final bool allowBadCertificates;

  CustomProxyHttpOverride.withProxy(
    this.proxyString, {
    this.allowBadCertificates = false,
  });

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        assert(this.proxyString != null && this.proxyString!.isNotEmpty,
            'You must set a valid proxy if you enable it!');
        return "PROXY " + (this.proxyString ?? '') + ";";
      }
      ..badCertificateCallback = this.allowBadCertificates
          ? (X509Certificate cert, String host, int port) => true
          : null;
  }
}
