import '../models/api_model.dart';
import '../models/login_model.dart';

class AuthState {
  final bool isLoading;
  final LoginModel? user;
  final ApiModel? apiModel;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.apiModel,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    LoginModel? user,
    ApiModel? apiModel,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      apiModel: apiModel ?? this.apiModel,
      error: error, // ✅ Don't default to the previous error
    );
  }
}
