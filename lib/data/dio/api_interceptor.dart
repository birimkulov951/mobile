import 'dart:async';
import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:mobile_ultra/domain/auth/token_entity.dart';
import 'package:mobile_ultra/repositories/charles_repository.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/repositories/token_repository.dart';
import 'package:mobile_ultra/utils/app_config.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';

class CommonRequestInterceptor extends QueuedInterceptor {
  CommonRequestInterceptor(
    this._dio,
    this._systemRepository,
    this._charlesRepository,
  );

  final Dio _dio;
  final SystemRepository _systemRepository;
  final CharlesRepository _charlesRepository;

  Map<String, String> get _baseHeaders => {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        Const.APP_VERSION: _systemRepository.appVersion
      };

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (Config.appFlavor == Flavor.DEVELOPMENT) {
      _checkForCharlesProxy(_dio, _charlesRepository);
    }

    options.headers.addAll(_baseHeaders);
    printLog('${options.method} >>> ${options.uri}');
    printLog('Query parameters: ${options.queryParameters}');
    printLog('Request data: ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    printLog(
        '${response.requestOptions.method} <<< ${response.requestOptions.uri}');
    printLog('Response data: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    printLog('${err.requestOptions.method} <<< ${err.requestOptions.uri}');
    printLog('Error data: ${err.response?.data}');
    if (err.type == DioErrorType.response) {
      final String errorMessage =
          '${err.requestOptions.method} ${err.requestOptions.path} [${err.response?.statusCode}]';
      AppMetrica.reportError(
          message: errorMessage,
          errorDescription: AppMetricaErrorDescription.fromCurrentStackTrace(
            message: '${err.response?.data}',
            type: errorMessage,
          ));
    }
    handler.next(err);
  }
}

class AuthorizedRequestInterceptor extends CommonRequestInterceptor {
  AuthorizedRequestInterceptor(
    Dio dio,
    SystemRepository systemRepository,
    CharlesRepository charlesRepository,
    this._tokenRepository,
  ) : super(dio, systemRepository, charlesRepository);

  final TokenRepository _tokenRepository;

  TokenEntity get _token => _tokenRepository.getToken();

  String get _bearerToken => '${_token.tokenType} ${_token.accessToken}';

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      options.headers[HttpHeaders.authorizationHeader] = _bearerToken;
      return super.onRequest(options, handler);
    } on DioError catch (e) {
      handler.reject(e, true);
    } on Object catch (e) {
      printLog(e);
    }
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      try {
        /// Refresh token and retry last request
        await _tokenRepository.refreshToken(_token);

        final request = err.requestOptions;
        final retryResponse = await _dio.request(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: Options(
            method: request.method,
            sendTimeout: request.sendTimeout,
            receiveTimeout: request.receiveTimeout,
            extra: request.extra,
            headers: request.headers,
            responseType: request.responseType,
            contentType: request.contentType,
            validateStatus: request.validateStatus,
            receiveDataWhenStatusError: request.receiveDataWhenStatusError,
            followRedirects: request.followRedirects,
            maxRedirects: request.maxRedirects,
            requestEncoder: request.requestEncoder,
            responseDecoder: request.responseDecoder,
            listFormat: request.listFormat,
          ),
        );
        handler.resolve(retryResponse);
      } on DioError catch (retryError) {
        return super.onError(retryError, handler);
      } on Object catch (_) {
        return super.onError(err, handler);
      }
    } else {
      return super.onError(err, handler);
    }
  }
}

void _checkForCharlesProxy(Dio dio, CharlesRepository repository) {
  final String? charlesIp = repository.charlesIpAddress();

  if (repository.isCharlesProxyEnabled() && charlesIp != null) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) => "PROXY $charlesIp:8888;";
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };
  }
}
