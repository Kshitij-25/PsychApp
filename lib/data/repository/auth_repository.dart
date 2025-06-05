import '../models/api_model.dart';
import '../models/login_model.dart';
import '../remote_data_source/auth_remote_source.dart';

class AuthRepository {
  final AuthRemoteSource _remoteSource;

  AuthRepository(this._remoteSource);

  Future<LoginModel?> login(String email, String password) async {
    try {
      final response = await _remoteSource.loginUser(email, password);
      return response;
    } catch (e) {
      print('Repository Login Error: $e');
      rethrow; // ✅ Just rethrow the original error without adding extra text
    }
  }

  // ✅ Registration with error handling
  Future<ApiModel?> registerUser(String email, String password, String role) async {
    try {
      final response = await _remoteSource.registerUser(email, password, role);
      return response;
    } catch (e) {
      print('Repository Registration Error: $e');
      rethrow;
    }
  }

  Future<ApiModel?> logoutUser() async {
    try {
      final response = await _remoteSource.logoutUser();
      return response;
    } catch (e) {
      print('Repository Logout Error: $e');
      rethrow;
    }
  }
}
