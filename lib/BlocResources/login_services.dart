import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LoginServicesBloc extends Validator{
  BehaviorSubject<String> _email = BehaviorSubject<String>();
  FirebaseManager _firebaseManager = FirebaseManager();

  Stream<String> get email => _email.stream.transform(validateEmail);
  Function(String) get emailChange => _email.sink.add;

  Stream<bool> get isValidField => email.map((newPassword) => true);

  Future<void> resetPassword(Function() onSuccess, Function(String) onError){
    return _firebaseManager.resetPassword(_email.value, onSuccess, onError);
  }

  Future<void> sendVerificationEmail(FirebaseUser user, Function() onSuccess, Function(String) onError){
    return _firebaseManager.resendVerificationEmail(user, onSuccess, onError);
  }

  void dispose(){
    _email.close();
  }
}