import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';

class AuthBloc with Validator{
  final BehaviorSubject<String> _email = BehaviorSubject();
  final BehaviorSubject<String> _password = BehaviorSubject();
  final BehaviorSubject<String> _fcmToken = BehaviorSubject();
  final BehaviorSubject<AdminUserInfo> _admin = BehaviorSubject();

  final _firebaseManager = FirebaseManager();

  reset(){
    _email.add(null);
    _password.add(null);
    _fcmToken.add(null);
    _admin.add(null);
  }

  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get isValidSignUpFields => Rx.combineLatest2(email, password, (e, p) => true);
  Stream<String> get fcmToken => _fcmToken.stream;
  Stream<AdminUserInfo> get admin => _admin.stream;
  
  Function(String) get emailChange => _email.sink.add;
  Function(String) get passwordChange => _password.sink.add;
  Sink<String> get fcmTokenChange => _fcmToken.sink;
  Sink<AdminUserInfo> get adminChange => _admin.sink;

  bool validateField(){
    bool isValidEmail = _email.value != null && _email.value.isNotEmpty;
    bool isValidPassword = _password.value != null && _password.value.isNotEmpty;
    
    return isValidEmail && isValidPassword;
  }

  Future<void> signIn({Function(AuthResult) onSuccess, Function(String) onError}){
    return _firebaseManager.signIn(
      email: _email.value, 
      password: _password.value, 
      onSuccess: onSuccess, 
      onError: onError);
  }

  Future<void> updateFcmToken(String adminID){
    return _firebaseManager.updateFcmToken(adminID, _fcmToken.value);
  }

  Future<AdminUserInfo> reteiveAdminInfo(String adminID) async{
    DocumentSnapshot adminDoc = await _firebaseManager.getAdminInfo(adminID);
    AdminUserInfo adminInfo = AdminUserInfo.fromMap(adminDoc)..id = adminID;
    return adminInfo;
  }

  void dispose() async{
    _email.close();
    _password.close();
    _fcmToken.close();
    _admin.close();
  }
}