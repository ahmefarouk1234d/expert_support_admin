import 'dart:async';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';

class AuthBloc with Validator{
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _fcmToken = BehaviorSubject<String>();
  final _admin = BehaviorSubject<AdminUserInfo>();

  final _firebaseManager = FirebaseManager();

  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get isValidSignUpFields => Observable.combineLatest2(email, password, (e, p) => true);
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

  Future<FirebaseUser> signIn(){
    return _firebaseManager.signIn(email: _email.value, password: _password.value);
  }

  Future<void> updateAdminDetails(String userId){
    final adminInfo = AdminUserInfo(id: userId, email: _email.value, role: "admin", fcmToken: _fcmToken.value);
    return _firebaseManager.saveAdminUser(adminInfo);
  }

  void saveAdminInfo(String userId){
    this._admin.add(AdminUserInfo(id: userId, email: _email.value, role: "admin", fcmToken: _fcmToken.value));
  }

  void dispose() async{
    _email.close();
    _password.close();
    _fcmToken.close();
    _admin.close();
  }
}