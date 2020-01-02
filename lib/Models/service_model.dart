import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCategory {
  String docID;
  num order;
  String id;
  String nameAr;
  String nameEn;
  bool isActive;
  List<ServiceType> serviceTypeList;

  ServiceCategory(
      {this.docID,
      this.order,
      this.id,
      this.nameAr,
      this.nameEn,
      this.isActive,
      this.serviceTypeList});

  _serivceMapToList(DocumentSnapshot doc) {
    Map<String, dynamic> serviceData = doc.data;
    this.docID = doc.documentID;
    this.id = serviceData["ID"];
    this.nameAr = serviceData["NameAr"];
    this.nameEn = serviceData["NameEn"];
    this.isActive = serviceData["IsActive"];
    this.serviceTypeList = ServiceType.fromListMap(serviceData["Items"]);
  }

  ServiceCategory.fromMap(DocumentSnapshot doc) {
    this._serivceMapToList(doc);
  }

  static List<ServiceCategory> fromListMap({List<DocumentSnapshot> docList}) {
    List<ServiceCategory> services = List();
    docList.forEach((doc) {
      if (doc.data["Items"] is List<dynamic>) {
        services.add(ServiceCategory().._serivceMapToList(doc));
      }
    });
    return services;
  }
}

class ServiceType {
  String id;
  String nameAr;
  String nameEn;
  String descAr;
  String descEn;
  String remarkAr;
  String remarkEn;
  String optionTitleAr;
  String optionTitleEn;
  num gauranteePeriodInDays;
  num minRate;
  List<MainService> mainServiceList;

  ServiceType(
      {this.id,
      this.nameEn,
      this.nameAr,
      this.descAr,
      this.descEn,
      this.remarkAr,
      this.remarkEn,
      this.optionTitleAr,
      this.optionTitleEn,
      this.gauranteePeriodInDays, 
      this.minRate,
      this.mainServiceList});

  _subSerivceMapToList(Map<dynamic, dynamic> subService) {
    this.id = subService["ID"];
    this.nameAr = subService["NameAr"];
    this.nameEn = subService["NameEn"];
    this.descAr = subService["DescAr"];
    this.descEn = subService["DescEn"];
    this.remarkAr = subService["RemarkAr"];
    this.remarkEn = subService["RemarkEn"];
    this.optionTitleAr = subService["OptionsTitleAr"];
    this.optionTitleEn = subService["OptionsTitleEn"];
    this.gauranteePeriodInDays = subService["GauranteePeriodInDays"];
    this.minRate = subService["MinRate"];
    this.mainServiceList = MainService.fromListMap(subService["items"]);
  }

  ServiceType.fromMap(Map<dynamic, dynamic> subService) {
    this._subSerivceMapToList(subService);
  }

  static List<ServiceType> fromListMap(List<dynamic> subServList) {
    List<ServiceType> subServices = List();
    subServList.forEach((subServ) {
      subServices.add(ServiceType().._subSerivceMapToList(subServ));
    });
    return subServices;
  }
}

class MainService {
  String id;
  String nameAr;
  String nameEn;
  String type;
  bool hasSub;
  num price;
  String priceDescAr;
  String priceDescEn;
  //List<ServicePrice> servicePrice;
  List<SubMainService> subMainServiceList;

  MainService({this.id, this.nameEn, this.nameAr, this.type, this.hasSub, this.price, this.priceDescAr, this.priceDescEn, this.subMainServiceList});

  _subSubSerivceMapToList(Map<dynamic, dynamic> mainService) {
    this.id = mainService["ID"];
    this.nameAr = mainService["NameAr"];
    this.nameEn = mainService["NameEn"];
    this.type = mainService["Type"];
    this.hasSub = mainService["HasSub"];
    if (this.hasSub){
      this.subMainServiceList = SubMainService.fromListMap(mainService["SubMainService"]);
    } else {
      this.price = mainService["Price"];
      this.priceDescAr = mainService["PriceDescAr"];
      this.priceDescEn = mainService["PriceDescEn"];
    }
    //this.servicePrice = ServicePrice.fromListMap(subSubService["Prices"]);
  }

  MainService.fromMap(Map<dynamic, dynamic> subSubService) {
    this._subSubSerivceMapToList(subSubService);
  }

  static List<MainService> fromListMap(List<dynamic> subSubServList) {
    List<MainService> subSubServices = List();
    subSubServList.forEach((subSubServ) {
      subSubServices.add(MainService().._subSubSerivceMapToList(subSubServ));
    });
    return subSubServices;
  }
}

class SubMainService {
  String id;
  String nameAr;
  String nameEn;
  num price;
  String priceDescAr;
  String priceDescEn;

  SubMainService({this.id, this.nameEn, this.nameAr, this.price, this.priceDescAr, this.priceDescEn});

  _servicePriceMapToList(Map<dynamic, dynamic> subMainService) {
    this.id = subMainService["ID"];
    this.nameAr = subMainService["NameAr"];
    this.nameEn = subMainService["NameEn"];
    this.price = subMainService["Price"];
    this.priceDescAr = subMainService["PriceDescAr"];
    this.priceDescEn = subMainService["PriceDescEn"];
  }

  SubMainService.from(Map<dynamic, dynamic> servicePrice) {
    this._servicePriceMapToList(servicePrice);
  }

  static List<SubMainService> fromListMap(List<dynamic> servicePriceList) {
    List<SubMainService> servicePrices = List();
    servicePriceList.forEach((price) {
      servicePrices.add(SubMainService().._servicePriceMapToList(price));
    });
    return servicePrices;
  }
}
