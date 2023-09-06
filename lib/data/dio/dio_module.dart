import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/dio/api_interceptor.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/repositories/token_repository.dart';
import 'package:mobile_ultra/utils/inject.dart';

const _requestTimeoutInMilliseconds = 40000;

@module
abstract class DioModule {
  @Named("Host")
  //TODO: перенести сюда когда будет удален Http
  String get host => Http.HOST;

  @Named("TestHost")
  //TODO: перенести сюда когда будет удален Http
  String get testHost => Http.TEST_HOST;

  @Named("Environment")
  //TODO: перенести сюда когда будет удален Http
  bool get isTest => Http.isTest;

  @singleton
  Future<Dio> getAuthorizedDioClient({
    @Named("Environment") required bool isTest,
    @Named("Host") required String host,
    @Named("TestHost") required String testHost,
    required TokenRepository tokenRepository,
  }) async {
    final _baseUrl = 'https://${isTest ? testHost : host}/';
    final authorizedDioClient = _createDioClient(_baseUrl);
    authorizedDioClient.interceptors.addAll([
      AuthorizedRequestInterceptor(
        authorizedDioClient,
        inject(),
        inject(),
        tokenRepository,
      ),
    ]);
    return authorizedDioClient;
  }

  @Named("UnauthorizedClient")
  @singleton
  Future<Dio> getUnauthorizedDioClient({
    @Named("Environment") required bool isTest,
    @Named("Host") required String host,
    @Named("TestHost") required String testHost,
  }) async {
    final _baseUrl = 'https://${isTest ? testHost : host}/';
    final unauthorizedDioClient = _createDioClient(_baseUrl);
    unauthorizedDioClient.interceptors.addAll([
      CommonRequestInterceptor(
        unauthorizedDioClient,
        inject(),
        inject(),
      ),
    ]);
    return unauthorizedDioClient;
  }

  Dio _createDioClient(String baseUrl) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: _requestTimeoutInMilliseconds,
      receiveTimeout: _requestTimeoutInMilliseconds,
    );
    return Dio(options);
  }
}
