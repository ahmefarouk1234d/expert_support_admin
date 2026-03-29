import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getUser() {
    User? user = _auth.currentUser;
    return user;
  }

  Future<void> signIn(String email, String password,
      Function(UserCredential) onSuccess, Function(String) onError) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      onSuccess(user);
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? e.code);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> signUp(String email, String password,
      Function(UserCredential) onSuccess, Function(String) onError) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      onSuccess(user);
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? e.code);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<void> changePassword(String newPassword, Function() onSuccess,
      Function(String) onError) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        onError("No user signed in");
        return;
      }
      await user.updatePassword(newPassword);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? e.code);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> resetPassword(
      String email, Function() onSuccess, Function(String) onError) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? e.code);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> resendVerificationEmail(
      User user, Function() onSuccess, Function(String) onError) async {
    try {
      await user.sendEmailVerification();
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? e.code);
    } catch (e) {
      onError(e.toString());
    }
  }
}
