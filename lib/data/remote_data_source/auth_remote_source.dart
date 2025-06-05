import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/constants/api_constants.dart';
import '../../shared/constants/hive_helper.dart';
import '../core/dio_client.dart';
import '../models/api_model.dart';
import '../models/login_model.dart';

class AuthRemoteSource {
  static final AuthRemoteSource _instance = AuthRemoteSource._internal();

  AuthRemoteSource._internal();

  factory AuthRemoteSource() => _instance;

  final DioClient _dioClient = DioClient();

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<LoginModel?> loginUser(String? email, String? password) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.loginUrl,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseJson = response.data;
        HiveHelper.saveUserData(responseJson['data']);
        await secureStorage.write(
          key: 'access_token',
          value: responseJson['data']['accessToken'],
        );
        return LoginModel.fromJson(responseJson['data']);
      } else {
        throw Exception('Login failed. Please try again.');
      }
    } catch (e) {
      print('Login Error: $e');
      throw e;
    }
  }

  Future<ApiModel?> registerUser(String? email, String? password, String? role) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.registerUserUrl,
        data: {
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        return ApiModel.fromJson(response.data);
      } else {
        throw Exception('Registration failed. Please try again.');
      }
    } catch (e) {
      print('Registration Error: $e');
      throw e;
    }
  }

  Future<ApiModel?> logoutUser() async {
    try {
      final response = await _dioClient.post(
        ApiConstants.logoutUser,
      );

      if (response.statusCode == 200) {
        print(response.data);
        await secureStorage.deleteAll();
        return ApiModel.fromJson(response.data);
      } else {
        throw Exception('Logout failed. Please try again.');
      }
    } catch (e) {
      print('Logout Error: $e');
      throw e;
    }
  }
}
