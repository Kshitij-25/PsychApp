import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/constants/api_constants.dart';

final secureStorage = FlutterSecureStorage();

class DioClient {
  static final DioClient _instance = DioClient._internal(); // ✅ Singleton instance

  factory DioClient() => _instance; // ✅ Factory constructor

  late Dio dio;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Paths that don't require authorization
        final noAuthPaths = [
          '/auth/login',
          '/auth/signup',
          '/create-user-profile',
          '/create-professional-profile',
          '/save-assessments',
          '/upload-profile-pic'
        ];

        // Check if the request path requires authorization
        final requiresAuth = !noAuthPaths.any((path) => options.path.contains(path));

        if (requiresAuth) {
          final accessToken = await _getAccessToken();

          if (accessToken != null && _isTokenExpired(accessToken)) {
            await _refreshToken();
            options.headers['Authorization'] = 'Bearer ${await _getAccessToken()}';
          } else if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }

        handler.next(options);
      },
      onError: (DioException error, handler) async {
        final funkyMessage = _handleError(error);
        print('Oops! $funkyMessage'); // Handle UI errors
        handler.next(error);
      },
    ));
  }

  Future<Response> get(String path) async {
    try {
      return await dio.get(path);
    } catch (e) {
      throw Exception('Oops! Something went sideways. Try again later.');
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } catch (e) {
      throw Exception('Hmm... that didn\'t work. Breathe. Try again.');
    }
  }

  Future<String?> _getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  bool _isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    // Decode Base64 URL payload
    try {
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final Map<String, dynamic> payloadMap = json.decode(payload);

      if (!payloadMap.containsKey('exp')) return true;

      final exp = DateTime.fromMillisecondsSinceEpoch(
        (payloadMap['exp'] * 1000).toInt(),
      );

      return DateTime.now().isAfter(exp);
    } catch (e) {
      print('Error decoding token payload: $e');
      return true;
    }
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await secureStorage.read(key: 'refresh_token');
    if (refreshToken != null) {
      try {
        final response = await Dio().post(
          ApiConstants.baseUrl + '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );
        final newAccessToken = response.data['accessToken'];
        await secureStorage.write(key: 'access_token', value: newAccessToken);
        return newAccessToken;
      } catch (e) {
        print(e.toString());
        throw e;
      }
    }
    return null;
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'The internet is taking a nap. Try again later.';
      case DioExceptionType.sendTimeout:
        return 'Sending took too long. Maybe the server needs a coffee?';
      case DioExceptionType.receiveTimeout:
        return 'Waiting for the server... forever. Let\'s try again.';
      case DioExceptionType.badResponse:
        return 'Server is feeling blue. Please try again soon.';
      case DioExceptionType.cancel:
        return 'Request was canceled. No worries, we\'re still here.';
      case DioExceptionType.unknown:
      default:
        return 'Something mysterious happened. Take a deep breath and retry.';
    }
  }
}
