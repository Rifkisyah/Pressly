import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Get current user
  static User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  /// Register with email and password
  static Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  /// Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // For web, use signInWithPopup which is more reliable
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        
        final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
        return userCredential;
      } else {
        // For mobile platforms, use google_sign_in package
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          // User cancelled the sign-in
          return null;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_failed') {
        throw 'Google Sign-In failed. Please check your SHA-1 fingerprint in Firebase Console and ensure google-services.json is valid.';
      }
      throw 'Google Sign-In Error: ${e.message}';
    } catch (e) {
      throw 'An error occurred during Google Sign-In: ${e.toString()}';
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      // Sign out from Google if signed in (only for non-web)
      if (!kIsWeb) {
        try {
          if (await _googleSignIn.isSignedIn()) {
            await _googleSignIn.signOut();
          }
        } catch (_) {
          // Ignore Google sign out errors
        }
      }
      // Sign out from Firebase
      await _auth.signOut();
    } catch (e) {
      throw 'An error occurred while signing out. Please try again.';
    }
  }

  /// Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
