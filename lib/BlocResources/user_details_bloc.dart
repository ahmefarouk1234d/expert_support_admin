import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class UserDetailsBloc{
  final _usre = BehaviorSubject<AdminUserInfo>();

  Stream<AdminUserInfo> get user => _usre.stream;
  Sink<AdminUserInfo> get userChange => _usre.sink;

  void dispose(){
    _usre.close();
  }
}