import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc extends Validator{
  final _newPassword = BehaviorSubject<String>();
  FirebaseManager _firebaseManager = FirebaseManager();

  Stream<String> get newPassword => _newPassword.stream.transform(validatePassword);
  Function(String) get newPasswordChange => _newPassword.sink.add;

  Observable<bool> get isValidField => newPassword.map((newPassword) => true);

  Future<void> changePassword(Function() onSuccess, Function(String) onError){
    return _firebaseManager.changePassword(_newPassword.value, onSuccess, onError);
  }

  void dispose(){
    _newPassword.close();
  }
}