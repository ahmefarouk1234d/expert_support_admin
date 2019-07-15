import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Auth{
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String email, String password) async{
    FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<void> signOut(){
    return _auth.signOut();
  }

}