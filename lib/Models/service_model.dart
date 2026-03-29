import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCategory {
  String? docID;
  num? order;
  String? id;
  String? nameAr;
  String? nameEn;
  bool? isActive;
  List<ServiceType>? serviceTypeList;

  ServiceCategory(
      {this.docID,
      this.order,
      this.id,
      this.nameAr,
      this.nameEn,
      this.isActive,
      this.serviceTypeList});

  void _serivceMapToList(DocumentSnapshot doc) {
    Map<String, dynamic> serviceData = doc.data() as Map<String, dynamic>;
    docID = doc.id;
    id = serviceData["ID"];
    nameAr = serviceData["NameAr"];
    nameEn = serviceData["NameEn"];
    isActive = serviceData["IsActive"];
    serviceTypeList = ServiceType.fromListMap(serviceData["Items"]);
  }

  ServiceCategory.fromMap(DocumentSnapshot doc) {
    _serivceMapToList(doc);
  }

  static List<ServiceCategory> fromListMap({required List<DocumentSnapshot> docList}) {
    List<ServiceCategory> services = <ServiceCategory>[];
    for (var doc in docList) {
      if ((doc.data() as Map<String, dynamic>)["Items"] is List<dynamic>) {
        services.add(ServiceCategory().._serivceMapToList(doc));
      }
    }
    return services;
  }
}

class ServiceType {
  String? id;
  String? nameAr;
  String? nameEn;
  String? descAr;
  String? descEn;
  String? remarkAr;
  String? remarkEn;
  String? optionTitleAr;
  String? optionTitleEn;
  num? gauranteePeriodInDays;
  num? minRate;
  List<MainService>? mainServiceList;

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

  void _subSerivceMapToList(Map<String, dynamic> subService) {
    id = subService["ID"];
    nameAr = subService["NameAr"];
    nameEn = subService["NameEn"];
    descAr = subService["DescAr"];
    descEn = subService["DescEn"];
    remarkAr = subService["RemarkAr"];
    remarkEn = subService["RemarkEn"];
    optionTitleAr = subService["OptionsTitleAr"];
    optionTitleEn = subService["OptionsTitleEn"];
    gauranteePeriodInDays = subService["GauranteePeriodInDays"];
    minRate = subService["MinRate"];
    mainServiceList = MainService.fromListMap(subService["items"]);
  }

  ServiceType.fromMap(Map<String, dynamic> subService) {
    _subSerivceMapToList(subService);
  }

  static List<ServiceType> fromListMap(List<dynamic> subServList) {
    List<ServiceType> subServices = <ServiceType>[];
    for (var subServ in subServList) {
      subServices.add(ServiceType().._subSerivceMapToList(subServ));
    }
    return subServices;
  }
}

class MainService {
  String? id;
  String? nameAr;
  String? nameEn;
  String? type;
  bool? hasSub;
  num? price;
  String? priceDescAr;
  String? priceDescEn;
  //List<ServicePrice> servicePrice;
  List<SubMainService>? subMainServiceList;

  MainService(
      {this.id,
      this.nameEn,
      this.nameAr,
      this.type,
      this.hasSub,
      this.price,
      this.priceDescAr,
      this.priceDescEn,
      this.subMainServiceList});

  void _subSubSerivceMapToList(Map<String, dynamic> mainService) {
    id = mainService["ID"];
    nameAr = mainService["NameAr"];
    nameEn = mainService["NameEn"];
    type = mainService["Type"];
    hasSub = mainService["HasSub"];
    if (hasSub!) {
      subMainServiceList =
          SubMainService.fromListMap(mainService["SubMainService"]);
    } else {
      price = mainService["Price"];
      priceDescAr = mainService["PriceDescAr"];
      priceDescEn = mainService["PriceDescEn"];
    }
    //this.servicePrice = ServicePrice.fromListMap(subSubService["Prices"]);
  }

  MainService.fromMap(Map<String, dynamic> subSubService) {
    _subSubSerivceMapToList(subSubService);
  }

  static List<MainService> fromListMap(List<dynamic> subSubServList) {
    List<MainService> subSubServices = <MainService>[];
    for (var subSubServ in subSubServList) {
      subSubServices.add(MainService().._subSubSerivceMapToList(subSubServ));
    }
    return subSubServices;
  }
}

class SubMainService {
  String? id;
  String? nameAr;
  String? nameEn;
  num? price;
  String? priceDescAr;
  String? priceDescEn;

  SubMainService(
      {this.id,
      this.nameEn,
      this.nameAr,
      this.price,
      this.priceDescAr,
      this.priceDescEn});

  void _servicePriceMapToList(Map<String, dynamic> subMainService) {
    id = subMainService["ID"];
    nameAr = subMainService["NameAr"];
    nameEn = subMainService["NameEn"];
    price = subMainService["Price"];
    priceDescAr = subMainService["PriceDescAr"];
    priceDescEn = subMainService["PriceDescEn"];
  }

  SubMainService.from(Map<String, dynamic> servicePrice) {
    _servicePriceMapToList(servicePrice);
  }

  static List<SubMainService> fromListMap(List<dynamic> servicePriceList) {
    List<SubMainService> servicePrices = <SubMainService>[];
    for (var price in servicePriceList) {
      servicePrices.add(SubMainService().._servicePriceMapToList(price));
    }
    return servicePrices;
  }
}
