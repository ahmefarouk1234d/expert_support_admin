import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/service_model.dart';
import 'package:rxdart/rxdart.dart';

class OrderOfferBloc extends Validator{
  final _serviceCategoty = BehaviorSubject<ServiceCategory>();
  final _serviceType = BehaviorSubject<ServiceType>();
  final _mainService = BehaviorSubject<MainService>();
  final _subMainService = BehaviorSubject<SubMainService>();
  final _titleAr = BehaviorSubject<String>();
  final _titleEn = BehaviorSubject<String>();
  final _descAr = BehaviorSubject<String>();
  final _descEn = BehaviorSubject<String>();
  final _price = BehaviorSubject<String>();
  final _quantity = BehaviorSubject<String>();
  FirebaseManager _firebaseManager = FirebaseManager();

  Stream<ServiceCategory> get serviceCategory => _serviceCategoty.stream.transform(validateServiceCategory);
  Function(ServiceCategory) get serviceCategoryChange => _serviceCategoty.sink.add;
  Stream<ServiceType> get serviceType => _serviceType.stream.transform(validateServiceType);
  Function(ServiceType) get serviceTypeChange => _serviceType.sink.add;
  Stream<MainService> get mainService => _mainService.stream.transform(validateMainService);
  Function(MainService) get mainServiceChange => _mainService.sink.add;
  Stream<SubMainService> get subMainService => _subMainService.stream.transform(validateSubMainService);
  Function(SubMainService) get subMainServiceChange => _subMainService.sink.add;
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

  Stream<bool> get isValidAddFields => Rx.combineLatest7(
    mainService,
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

  Stream<bool> get isValidAddFieldsWithSub => Rx.combineLatest8(
    mainService,
    subMainService,
    offerTitleAr, 
    offerTitleEn, 
    offerDescAr,
    offerDescEn,
    price,
    quantity,
    (s, ss, tr, te, da, de, p, q) {
      return true;
    }
  );

  Future<void> saveOrderOfferInfo() async{
    var priceForOne = double.parse(_price.value);
    var qauntity = int.parse(_quantity.value);

    OrderOfferInfo offerInfo = OrderOfferInfo(
      serviceCategoryID: _serviceCategoty.value.id,
      serviceTypeID: _serviceType.value.id,
      mainServiceID: _mainService.value.id,
      subMainServiceID: _subMainService.value == null ? "" : _subMainService.value.id,
      titleAr: _titleAr.value,
      titleEn: _titleEn.value,
      descAr: _descAr.value,
      descEn: _descEn.value,
      priceForOne: priceForOne,
      qauntity: qauntity,
      originalPrice: _subMainService.value == null ? _mainService.value.price : _subMainService.value.price
    );

    return _firebaseManager.saveOrderOffer(offerInfo);
  }

  void dispose(){
    _serviceCategoty.close();
    _serviceType.close();
    _mainService.close();
    _subMainService.close();
    _titleAr.close();
    _titleEn.close();
    _descAr.close();
    _descEn.close();
    _price.close();
    _quantity.close();
  }
}