// auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance, GoogleSignIn.instance);
});

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthService(this._auth, this._googleSignIn);

  // Email & Password Sign Up
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (role == 'user') {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
              'email': email,
              'role': role,
              'uid': userCredential.user?.uid,
            });
      } else {
        FirebaseFirestore.instance
            .collection('psychologist')
            .doc(userCredential.user?.uid)
            .set({
              'email': email,
              'role': role,
              'uid': userCredential.user?.uid,
            });
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Email & Password Sign In
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle({required String role}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) throw 'Google sign in aborted';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      FirebaseFirestore.instance.collection('users').doc(googleUser.id).set({
        'email': googleUser.email,
        'role': role,
        'uid': googleUser.id,
      });

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reset Password
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      // await Future.wait([]);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> deleteFirebaseAccount({required String password}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      print('No user is currently signed in.');
      return;
    }

    try {
      // Re-authentication might be required in some cases
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      // Re-authenticate the user
      await user.reauthenticateWithCredential(credential);

      // Delete Firestore data
      final userDocRef = firestore.collection('users').doc(user.uid);
      await userDocRef.delete();
      print('User Firestore data deleted successfully.');

      // Delete the account
      await user.delete();
      print('User account deleted successfully.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('User needs to re-authenticate before deleting their account.');
      } else {
        print('Error deleting account: ${e.message}');
      }
    } on FirebaseException catch (e) {
      print('Failed to delete Firestore data: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  // Helper method to handle auth exceptions
  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        // Email Validation Errors
        case 'invalid-email':
          return Exception('Invalid email address format');

        // Account Existence Errors
        case 'email-already-in-use':
          return Exception('Email is already registered');
        case 'account-exists-with-different-credential':
          return Exception('Account exists with different sign-in method');

        // Authentication Errors
        case 'wrong-password':
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
          return Exception('Invalid login credentials');

        // User Account Errors
        case 'user-not-found':
          return Exception('No account found with this email');
        case 'user-disabled':
          return Exception('User account has been disabled');

        // Password Errors
        case 'weak-password':
          return Exception('Password is too weak');

        // Network and Request Errors
        case 'network-request-failed':
          return Exception('Network error. Check your connection');
        case 'too-many-requests':
          return Exception('Too many requests. Please try again later');

        // Token and Authentication Flow Errors
        case 'user-token-expired':
          return Exception('Session expired. Please log in again');
        case 'operation-not-allowed':
          return Exception('Sign-in method not enabled');

        // Verification and Credential Errors
        case 'invalid-verification-code':
          return Exception('Invalid verification code');
        case 'invalid-verification-id':
          return Exception('Invalid verification ID');

        // Miscellaneous Errors
        case 'missing-android-pkg-name':
          return Exception('Android package name missing');
        case 'missing-continue-uri':
          return Exception('Continue URL is missing');
        case 'invalid-continue-uri':
          return Exception('Invalid continue URL');
        case 'unauthorized-continue-uri':
          return Exception('Unauthorized continue URL domain');

        default:
          return Exception(e.message ?? 'Authentication error occurred');
      }
    }
    return Exception('An unexpected error occurred');
  }
}
