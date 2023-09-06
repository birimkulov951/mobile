// ignore_for_file: unawaited_futures, constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:mobile_ultra/domain/auth/token_entity.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/repositories/token_repository.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/utils/u.dart';

const _requestTimeout = Duration(seconds: 40);

class Http {
  Http({
    required this.path,
  }) {
    _client = RetryClient(
      Client(),
      retries: 1,
      when: (response) {
        return response.statusCode == HttpStatus.unauthorized;
      },
      onRetry: (req, res, retryCount) async {
        await _tokenRepository.refreshToken(_token);
        req.headers[HttpHeaders.authorizationHeader] =
            '${_token.tokenType} ${_token.accessToken}';
      },
    );
  }

  static const String HOST = 'm.example.com';
  static const String TEST_HOST = 'mdev.example.com';
  static const String URL = "https://$HOST/";

  final String path;

  static const bool isTest = bool.hasEnvironment("isTest");

  final Connectivity _connectivity = Connectivity();

  late final Client _client;

  final TokenRepository _tokenRepository = inject();

  final SystemRepository _systemRepository = inject();

  TokenEntity get _token => _tokenRepository.getToken();

  Map<String, String> getHeaders(Map<String, String>? header) => {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        Const.APP_VERSION: _systemRepository.appVersion,
        ...?header,
      };

  void makePost(
    HttpView view, {
    Map<String, String>? header,
    dynamic data,
    List<String>? pathSegments,
    bool testUrl = isTest,
  }) async {
    final bool connected = await _isHaveMobileOrWifiConnectivity();
    if (!connected) {
      view.onFail(locale.getText('no_inet_connection'));
      return;
    }

    final url = Uri(
      scheme: 'https',
      host: testUrl ? TEST_HOST : HOST,
      path: Uri.parse(path).path + Uri(pathSegments: pathSegments).toString(),
      query: Uri.parse(path).query,
    );

    printLog('POST >>> $url');
    printLog(data);

    _client.post(url, headers: getHeaders(header), body: data).then((response) {
      printLog('POST <<< ${response.request?.url}');
      printLog(response.request?.headers ?? {});
      printLog(response.body);

      final responseBody = utf8.decode(response.bodyBytes);

      if (_isSuccess(response.statusCode)) {
        view.onSuccess(responseBody);
      } else {
        final errorBody = jsonDecode(responseBody);
        if (errorBody is Map &&
            (errorBody.containsKey('details') ||
                errorBody.containsKey('title'))) {
          if (LocaleHelper.currentLangCode == LocaleHelper.Uzbek &&
              errorBody.containsKey('uz')) {
            view.onFail(_errorDetails(errorBody['detail']),
                title: errorBody['uz'], errorBody: errorBody);
          } else if (LocaleHelper.currentLangCode == LocaleHelper.Russian &&
              errorBody.containsKey('ru')) {
            view.onFail(_errorDetails(errorBody['detail']),
                title: errorBody['ru'], errorBody: errorBody);
          } else if (LocaleHelper.currentLangCode == LocaleHelper.English &&
              errorBody.containsKey('en')) {
            view.onFail(_errorDetails(errorBody['detail']),
                title: errorBody['en'], errorBody: errorBody);
          } else {
            view.onFail(_errorDetails(errorBody['detail']),
                title: errorBody['title'], errorBody: errorBody);
          }
        } else {
          view.onFail(
            _httpMessageByCode(
              response.statusCode,
              response.reasonPhrase ?? '',
            ),
          );
        }
      }
    }).catchError((e, st) {
      printLog('$e $st');
      view.onFail(locale.getText('unknown_error'));
    }).timeout(_requestTimeout, onTimeout: () async {
      view.onFail(locale.getText('check_internet_conn'));
      return null;
    });
  }

  void makeGet(
    HttpView view, {
    Map<String, String>? header,
    Map<String, dynamic>? params,
    List<String>? pathSegments,
    bool testUrl = isTest,
  }) async {
    final bool connected = await _isHaveMobileOrWifiConnectivity();
    if (!connected) {
      view.onFail(locale.getText('no_inet_connection'));
      return;
    }

    final url = Uri(
      scheme: 'https',
      host: testUrl ? TEST_HOST : HOST,
      path: path + Uri(pathSegments: pathSegments).toString(),
      queryParameters: params,
    );

    printLog('GET >>> $url');

    _client.get(url, headers: getHeaders(header)).then((response) {
      printLog('GET <<< ${response.request?.url}');
      printLog(response.request?.headers ?? {});
      printLog(response.body);

      final responseBody = utf8.decode(response.bodyBytes);
      if (_isSuccess(response.statusCode)) {
        view.onSuccess(responseBody);
      } else {
        final errorBody = jsonDecode(responseBody);
        if (errorBody is Map &&
            (errorBody.containsKey('details') ||
                errorBody.containsKey('title'))) {
          view.onFail(_errorDetails(errorBody['detail']),
              title: errorBody['title'], errorBody: errorBody);
        } else {
          view.onFail(
            _httpMessageByCode(
              response.statusCode,
              response.reasonPhrase ?? '',
            ),
          );
        }
      }
    }).catchError((e, st) {
      printLog('$e $st');
      view.onFail(locale.getText('unknown_error'));
    }).timeout(_requestTimeout, onTimeout: () async {
      view.onFail(locale.getText('check_internet_conn'));
    });
  }

  void makeDelete(
    HttpView view, {
    Map<String, String>? header,
    List<String>? params,
    bool testUrl = isTest,
  }) async {
    final bool connected = await _isHaveMobileOrWifiConnectivity();
    if (!connected) {
      view.onFail(locale.getText('no_inet_connection'));
      return;
    }

    final url = Uri(
        scheme: 'https',
        host: testUrl ? TEST_HOST : HOST,
        path: path + Uri(pathSegments: params).toString());

    printLog('DELETE >>> $url');

    _client.delete(url, headers: getHeaders(header)).then((response) {
      printLog('DELETE <<< ${response.request?.url}');
      printLog(response.request?.headers ?? {});
      printLog(response.body);

      final responseBody = utf8.decode(response.bodyBytes);

      if (_isSuccess(response.statusCode)) {
        view.onSuccess(responseBody);
      } else {
        final errorBody = jsonDecode(responseBody);
        if (errorBody is Map &&
            (errorBody.containsKey('details') ||
                errorBody.containsKey('title'))) {
          view.onFail(_errorDetails(errorBody['detail']),
              title: errorBody['title'], errorBody: errorBody);
        } else {
          view.onFail(
            _httpMessageByCode(
              response.statusCode,
              response.reasonPhrase ?? '',
            ),
          );
        }
      }
    }).catchError((e, st) {
      printLog('$e $st');
      view.onFail(locale.getText('unknown_error'));
    }).timeout(_requestTimeout, onTimeout: () async {
      view.onFail(locale.getText('check_internet_conn'));
      return null;
    });
  }

  void makePut(
    HttpView view, {
    Map<String, String>? header,
    dynamic data,
    bool testUrl = isTest,
  }) async {
    final bool connected = await _isHaveMobileOrWifiConnectivity();
    if (!connected) {
      view.onFail(locale.getText('no_inet_connection'));
      return;
    }

    final url = Uri(
      scheme: 'https',
      host: testUrl ? TEST_HOST : HOST,
      path: path,
    );

    printLog('PUT >>> $url');

    _client.put(url, headers: getHeaders(header), body: data).then((response) {
      printLog('PUT <<< ${response.request?.url}');
      printLog(response.request?.headers ?? {});
      printLog(response.body);

      final responseBody = utf8.decode(response.bodyBytes);

      if (_isSuccess(response.statusCode)) {
        view.onSuccess(responseBody);
      } else {
        final errorBody = jsonDecode(responseBody);
        if (errorBody is Map &&
            (errorBody.containsKey('details') ||
                errorBody.containsKey('title'))) {
          view.onFail(_errorDetails(errorBody['detail']),
              title: errorBody['title'], errorBody: errorBody);
        } else {
          view.onFail(
            _httpMessageByCode(
              response.statusCode,
              response.reasonPhrase ?? '',
            ),
          );
        }
      }
    }).catchError((e, st) {
      printLog('$e $st');
      view.onFail(locale.getText('unknown_error'));
    }).timeout(_requestTimeout, onTimeout: () async {
      view.onFail(locale.getText('check_internet_conn'));
      return null;
    });
  }

  bool _isSuccess(code) => code >= 200 && code < 300;

  Future<bool> _isHaveMobileOrWifiConnectivity() async {
    final ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  String _httpMessageByCode(int code, String reason) {
    /// TODO reason выглядит ненужным
    if (code >= 400 && code <= 499) {
      return locale.getText('incorrect_data');
    }

    if (code >= 500) {
      return locale.getText('server_unavailable');
    }

    return locale.getText('unknown_error');
  }

  String _errorDetails(String details) {
    switch (details) {
      case 'internal_error':
        return locale.getText('server_unavailable');
      default:
        return details;
    }
  }
}
