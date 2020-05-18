import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/discount_model.dart';
import 'package:rxdart/rxdart.dart';

class DiscountBloc extends Validator{
  final _code = BehaviorSubject<String>();
  final _percent = BehaviorSubject<String>();
  FirebaseManager _firebaseManager = FirebaseManager();

  Stream<String> get code => _code.stream.transform(validateDiscountCode);
  Function(String) get codeChange => _code.sink.add;
  Stream<String> get percent => _percent.stream.transform(validateDiscountPercent);
  Function(String) get percentChange => _percent.sink.add;

  Stream<bool> get isValidAddFields => Rx.combineLatest2(
    code,
    percent, 
    (c, p) {
      return true;
    }
  );

  Future<void> saveDiscountInfo(){
    final int percentToInt = int.parse(_percent.value);

    DiscountInfo discountInfo = DiscountInfo(code: _code.value, percent: percentToInt, isValid: true);
    
    return _firebaseManager.saveDiscountCode(discountInfo);
  }

  void dispose(){
    _code.close();
    _percent.close();
  }
}