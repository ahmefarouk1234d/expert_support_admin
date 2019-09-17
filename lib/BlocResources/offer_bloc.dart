import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/service_model.dart';
import 'package:rxdart/rxdart.dart';

class OfferBloc extends Validator{
  final _service = BehaviorSubject<Service>();
  final _offerTitleAr = BehaviorSubject<String>();
  final _offerTitleEn = BehaviorSubject<String>();
  final _offerDescAr = BehaviorSubject<String>();
  final _offerDescEn = BehaviorSubject<String>();
  final _price = BehaviorSubject<String>();
  final _quantity = BehaviorSubject<String>();
  FirebaseManager _firebaseManager = FirebaseManager();

  Stream<Service> get service => _service.stream.transform(validateService);
  Function(Service) get serviceChange => _service.sink.add;
  Stream<String> get offerTitleAr => _offerTitleAr.stream.transform(validateTextField);
  Function(String) get offerTitleArChange => _offerTitleAr.sink.add;
  Stream<String> get offerTitleEn => _offerTitleEn.stream.transform(validateTextField);
  Function(String) get offerTitleEnChange => _offerTitleEn.sink.add;
  Stream<String> get offerDescAr => _offerDescAr.stream.transform(validateTextField);
  Function(String) get offerDescArChange => _offerDescAr.sink.add;
  Stream<String> get offerDescEn => _offerDescEn.stream.transform(validateTextField);
  Function(String) get offerDescEnChange => _offerDescEn.sink.add;
  Stream<String> get price => _price.stream.transform(validateTextField);
  Function(String) get priceChange => _price.sink.add;
  Stream<String> get quantity => _quantity.stream.transform(validateTextField);
  Function(String) get quantityChange => _quantity.sink.add;

  Observable<bool> get isValidAddFields => Observable.combineLatest7(
    service, 
    offerTitleAr, 
    offerTitleEn, 
    offerDescAr,
    offerDescEn,
    price,
    quantity,
    (s, tr, te, da, de, p, q) {
      return true;
    }
  );

  Future<void> saveOfferInfo(){
    OfferInfo offerInfo = OfferInfo(
      servID: _service.value.docID,
      servNameAr: _service.value.nameAr,
      servNameEn: _service.value.nameEn,
      offerTitleAr: _offerTitleAr.value,
      offerTitleEn: _offerTitleEn.value,
      offerDescAr: _offerDescAr.value,
      offerDescEn: _offerDescEn.value,
      price: _price.value,
      qauntity: _quantity.value,
    );

    return _firebaseManager.saveOffer(offerInfo);
  }

  void dispose(){
    _service.close();
    _offerTitleAr.close();
    _offerTitleEn.close();
    _offerDescAr.close();
    _offerDescEn.close();
    _price.close();
    _quantity.close();
  }
}