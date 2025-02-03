// auth_state.dart
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/enums/auth_state.dart';
import '../../data/remote_data_source/firebase_auth.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authStateSubscription;

  AuthStateNotifier(this._authService) : super(AuthState()) {
    // Listen to auth state changes and update state
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (mounted) {
          state = state.copyWith(user: user);
        }
      },
    );
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid updates after disposal
    _authStateSubscription?.cancel();
    _authStateSubscription = null;
    super.dispose();
  }

  Future<void> signUpWithEmail(String email, String password, String role) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.signUpWithEmail(email: email, password: password, role: role);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // This ensures the error is propagated
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final userCredential = await _authService.signInWithEmail(email: email, password: password);
      state = state.copyWith(user: userCredential.user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // This ensures the error is propagated
    }
  }

  Future<void> signInWithGoogle(String role) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.signInWithGoogle(role: role);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // This ensures the error is propagated
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.resetPassword(email: email);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // This ensures the error is propagated
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.signOut();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // This ensures the error is propagated
    }
  }

  Future<void> deleteFirebaseAccount(String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.deleteFirebaseAccount(password: password);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // This ensures the error is propagated
    }
  }
}

// Provider
final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});
