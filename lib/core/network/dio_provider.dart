import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.options = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(
      milliseconds: ApiConstants.connectionTimeout,
    ),
    receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
    responseType: ResponseType.json,
  );

  dio.interceptors.addAll([
    AuthInterceptor(),
    LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
});
