import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/service_model.dart';
import 'package:rxdart/rxdart.dart';

class OrderOfferBloc extends Validator{
  final _service = BehaviorSubject<Service>();
  final _subService = BehaviorSubject<SubService>();
  final _subSubService = BehaviorSubject<SubSubService>();
  final _titleAr = BehaviorSubject<String>();
  final _titleEn = BehaviorSubject<String>();
  final _descAr = BehaviorSubject<String>();
  final _descEn = BehaviorSubject<String>();
  final _price = BehaviorSubject<String>();
  final _quantity = BehaviorSubject<String>();
  FirebaseManager _firebaseManager = FirebaseManager();

  Stream<Service> get service => _service.stream.transform(validateService);
  Function(Service) get serviceChange => _service.sink.add;
  Stream<SubService> get subService => _subService.stream.transform(validateSubService);
  Function(SubService) get subServiceChange => _subService.sink.add;
  Stream<SubSubService> get subSubService => _subSubService.stream.transform(validateSubSubService);
  Function(SubSubService) get subSubServiceChange => _subSubService.sink.add;
  Stream<String> get offerTitleAr => _titleAr.stream.transform(validateTextField);
  Function(String) get offerTitleArChange => _titleAr.sink.add;
  Stream<String> get offerTitleEn => _titleEn.stream.transform(validateTextField);
  Function(String) get offerTitleEnChange => _titleEn.sink.add;
  Stream<String> get offerDescAr => _descAr.stream.transform(validateTextField);
  Function(String) get offerDescArChange => _descAr.sink.add;
  Stream<String> get offerDescEn => _descEn.stream.transform(validateTextField);
  Function(String) get offerDescEnChange => _descEn.sink.add;
  Stream<String> get price => _price.stream.transform(validateNumberTextField);
  Function(String) get priceChange => _price.sink.add;
  Stream<String> get quantity => _quantity.stream.transform(validateNumberTextField);
  Function(String) get quantityChange => _quantity.sink.add;

  Observable<bool> get isValidAddFields => Observable.combineLatest9(
    service,
    subService,
    subSubService,
    offerTitleAr, 
    offerTitleEn, 
    offerDescAr,
    offerDescEn,
    price,
    quantity,
    (s, ss, sss, tr, te, da, de, p, q) {
      return true;
    }
  );

  Future<void> saveOrderOfferInfo(){
    var priceForOne = double.parse(_price.value);
    var qauntity = int.parse(_quantity.value);

    OrderOfferInfo offerInfo = OrderOfferInfo(
      servID: _service.value.docID,
      subServID: _subService.value.id,
      orderServID: _subSubService.value.id,
      titleAr: _titleAr.value,
      titleEn: _titleEn.value,
      descAr: _descAr.value,
      descEn: _descEn.value,
      priceForOne: priceForOne,
      qauntity: qauntity,
    );

    return _firebaseManager.saveOrderOffer(offerInfo);
  }

  void dispose(){
    _service.close();
    _subService.close();
    _subSubService.close();
    _titleAr.close();
    _titleEn.close();
    _descAr.close();
    _descEn.close();
    _price.close();
    _quantity.close();
  }
}