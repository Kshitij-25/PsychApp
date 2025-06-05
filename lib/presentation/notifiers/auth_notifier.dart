// auth_state.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/enums/auth_state.dart';
import '../../data/models/api_model.dart';
import '../../data/models/login_model.dart';
import '../../data/repository/auth_repository.dart';
import '../../shared/constants/hive_helper.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState());

  /// ✅ Login Function
  Future<LoginModel?> login(String email, String password) async {
    try {
      _setLoading(true);

      final user = await _authRepository.login(email, password);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userRole', user.role ?? '');

        state = state.copyWith(user: user, isLoading: false, error: null);
        return user;
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      _setError(e.toString()); // ✅ Directly set the original error message
      rethrow; // ✅ Re-throw without wrapping
    } finally {
      _setLoading(false);
    }
  }

  /// ✅ Register Function
  Future<ApiModel?> registerUser(String email, String password, String role) async {
    try {
      _setLoading(true);

      final response = await _authRepository.registerUser(email, password, role);

      if (response != null) {
        state = state.copyWith(isLoading: false);
        return response;
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      _setError('Registration error: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// ✅ Logout Function
  Future<bool> logoutUser() async {
    try {
      _setLoading(true);

      final response = await _authRepository.logoutUser();

      // ✅ Clear local storage
      if (response?.message == "Logout successful") {
        await HiveHelper.deleteUser();
        state = AuthState();
        return true;
      } else {
        state = AuthState();
        return false;
      }
      // ✅ Reset state
    } catch (e) {
      _setError('Logout error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 🔑 Helper Methods
  void _setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void _setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }
}

// class AuthStateNotifier extends StateNotifier<AuthState> {
//   final AuthService _authService;
//   StreamSubscription<User?>? _authStateSubscription;

//   AuthStateNotifier(this._authService) : super(AuthState()) {
//     // Listen to auth state changes and update state
//     _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen(
//       (user) {
//         if (mounted) {
//           state = state.copyWith(user: user);
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     // Cancel the subscription to avoid updates after disposal
//     _authStateSubscription?.cancel();
//     _authStateSubscription = null;
//     super.dispose();
//   }

//   Future<void> signUpWithEmail(String email, String password, String role) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _authService.signUpWithEmail(email: email, password: password, role: role);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow; // This ensures the error is propagated
//     }
//   }

//   Future<void> signInWithEmail(String email, String password) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       final userCredential = await _authService.signInWithEmail(email: email, password: password);
//       state = state.copyWith(user: userCredential.user, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow; // This ensures the error is propagated
//     }
//   }

//   Future<void> signInWithGoogle(String role) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _authService.signInWithGoogle(role: role);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow; // This ensures the error is propagated
//     }
//   }

//   Future<void> resetPassword({required String email}) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _authService.resetPassword(email: email);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow; // This ensures the error is propagated
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _authService.signOut();
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow; // This ensures the error is propagated
//     }
//   }

//   Future<void> deleteFirebaseAccount(String password) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _authService.deleteFirebaseAccount(password: password);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow; // This ensures the error is propagated
//     }
//   }
// }

// // Provider
// final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
//   final authService = ref.watch(authServiceProvider);
//   return AuthStateNotifier(authService);
// });
