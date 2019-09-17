import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class Auth{
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(
    String email, 
    String password,
    Function(FirebaseUser) onSuccess,
    Function(String) onError) async{
    try{
      FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      onSuccess(user);
    } on PlatformException catch(e){
      onError(e.message);
    }
  }

  Future<void> signUp(
    String email, 
    String password, 
    Function(FirebaseUser) onSuccess, 
    Function(String) onError) async{
    try{
      FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      onSuccess(user);
    } on PlatformException catch(e){
      onError(e.message);
    }
  }

  Future<void> signOut(){
    return _auth.signOut();
  }

  Future<void> changePassword(String newPassword, Function() onSuccess, Function(String) onError) async{
    try{
      FirebaseUser user = await _auth.currentUser();
      await user.updatePassword(newPassword);
      onSuccess();
    } on PlatformException catch(e){
      onError(e.message);
    }
  }

  Future<void> resetPassword(String email, Function() onSuccess, Function(String) onError) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      onSuccess();
    } on PlatformException catch(e){
      onError(e.message);
    }
  }

  Future<void> resendVerificationEmail(FirebaseUser user, Function() onSuccess, Function(String) onError) async{
    try{
      await user.sendEmailVerification();
      onSuccess();
    } on PlatformException catch(e){
      onError(e.message);
    }
  }

}