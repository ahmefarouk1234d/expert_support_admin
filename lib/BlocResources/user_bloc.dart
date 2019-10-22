import 'dart:async';

import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends Validator{
  final _name = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _reEnterPassword = BehaviorSubject<String>();
  final _role = BehaviorSubject<String>();
  FirebaseManager _firebaseManager = FirebaseManager();

  Stream<String> get name => _name.stream.transform(validateUsername);
  Function(String) get nameChange => _name.sink.add;
  Stream<String> get phone => _phone.stream.transform(validatePhone);
  Function(String) get phoneChange => _phone.sink.add;
  Stream<String> get email => _email.stream.transform(validateEmail);
  Function(String) get emailChange => _email.sink.add;
  Stream<String> get password => _password.stream.transform(validatePassword);
  Function(String) get passwordChange => _password.sink.add;
  Stream<String> get reEnterPassword => _reEnterPassword.stream.transform(validatePassword);
  Function(String) get reEnterPasswordChange => _reEnterPassword.sink.add;
  Stream<String> get role => _role.stream.transform(validateUserRole);
  Function(String) get roleChange => _role.sink.add;

  Observable<bool> get isValidAddFields => Observable.combineLatest6(
    name, 
    email, 
    phone, 
    password,
    reEnterPassword,
    role,
    (n, e, p, ps, rps, r) {
      return true;
    }
  );

  Observable<bool> get isValidUpdateFields => Observable.combineLatest4(
    name, 
    email, 
    phone, 
    role,
    (n, e, p, r) {
      return true;
    }
  );

  Future<void> signUp({Function(AuthResult) onSuccess, Function(String) onError}){
    return _firebaseManager.signUp(email: _email.value, password: _password.value, onSuccess: onSuccess, onError: onError);
  }

  Future<void> saveAdminInfo(String id){
    String phoneNumber = "+966" + _phone.value;
    AdminUserInfo admin = AdminUserInfo(
      id: id,
      name: _name.value, 
      email: _email.value, 
      phone: phoneNumber,
      role: _role.value,
      fcmToken: "",
      status: AdminUserStatus.active,
      dateCreated: DateTime.now().toUtc().millisecondsSinceEpoch,
      dateUpdated: DateTime.now().toUtc().millisecondsSinceEpoch
    );
    return _firebaseManager.saveAdminUser(admin);
  }

  Future<void> updateAdminInfo(String id){
    String phoneNumber = "+966" + _phone.value;
    AdminUserInfo admin = AdminUserInfo(
      id: id,
      name: _name.value, 
      email: _email.value, 
      phone: phoneNumber,
      role: _role.value,
      dateUpdated: DateTime.now().toUtc().millisecondsSinceEpoch
    );
    return _firebaseManager.updateAdminUser(admin);
  }

  Future<void> deleteAdminInfo(String id){
    AdminUserInfo admin = AdminUserInfo(
      id: id,
      status: AdminUserStatus.deleted,
      dateUpdated: DateTime.now().toUtc().millisecondsSinceEpoch
    );
    return _firebaseManager.deleteAdminUser(admin);
  }

  dispose() {
    _name.close();
    _phone.close();
    _email.close();
    _password.close();
    _reEnterPassword.close();
    _role.close();
  }
}