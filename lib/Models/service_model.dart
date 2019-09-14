import 'package:cloud_firestore/cloud_firestore.dart';

class Service{
  String docID;
  String nameAr;
  String nameEn;
  List<SubService> subServices;

  Service({this.docID, this.nameAr, this.nameEn, this.subServices});

  _serivceMapToList(DocumentSnapshot doc){
    Map<String, dynamic> serviceData = doc.data;
      this.docID = doc.documentID;
      this.nameAr = serviceData["NameAr"];
      this.nameEn = serviceData["NameEn"];
      this.subServices = SubService.fromListMap(serviceData["Items"]);
  }
  
  Service.fromMap(DocumentSnapshot doc){
    this._serivceMapToList(doc);
  }

  static List<Service> fromListMap({List<DocumentSnapshot> docList}){
    List<Service> services = List();
    docList.forEach(
      (doc) {
        if (doc.data["Items"] is List<dynamic>){
          services.add(Service().._serivceMapToList(doc));
        }
      }
    );
    return services;
  }
}

class SubService{
  String nameAr;
  String nameEn;
  String descAr;
  String descEn;
  List<SubSubService> subSubServices;

  SubService({this.nameEn, this.nameAr, this.descAr, this.descEn, this.subSubServices});

  _subSerivceMapToList(Map<dynamic, dynamic> subService){
    this.nameAr = subService["NameAr"];
    this.nameEn = subService["NameEn"];
    this.descAr = subService["DescAr"];
    this.descEn = subService["DescEn"];
    this.subSubServices = SubSubService.fromListMap(subService["items"]);
  }

  SubService.fromMap(Map<dynamic, dynamic> subService){
    this._subSerivceMapToList(subService);
  }

  static List<SubService> fromListMap(List<dynamic> subServList){
    List<SubService> subServices = List();
    subServList.forEach(
      (subServ) {
          subServices.add(SubService().._subSerivceMapToList(subServ));
      }
    );
    return subServices;
  }
}

class SubSubService{
  String nameAr;
  String nameEn;
  List<ServicePrice> servicePrice;

  SubSubService({this.nameEn, this.nameAr, this.servicePrice});

  _subSubSerivceMapToList(Map<dynamic, dynamic> subSubService){
    this.nameAr = subSubService["NameAr"];
    this.nameEn = subSubService["NameEn"];
    this.servicePrice = ServicePrice.fromListMap(subSubService["Prices"]);
  }

  SubSubService.fromMap(Map<dynamic, dynamic> subSubService){
    this._subSubSerivceMapToList(subSubService);
  }

  static List<SubSubService> fromListMap(List<dynamic> subSubServList){
    List<SubSubService> subSubServices = List();
    subSubServList.forEach(
      (subSubServ) {
          subSubServices.add(
            SubSubService().._subSubSerivceMapToList(subSubServ));
      }
    );
    return subSubServices;
  }
}

class ServicePrice{
  String descAr;
  String descEn;
  num rangeFrom;
  num rangeTo;
  num value;

  ServicePrice({this.descAr, this.descEn, this.rangeFrom, this.rangeTo, this.value});

  _servicePriceMapToList(Map<dynamic, dynamic> servicePrice){
    this.descAr = servicePrice["DescAr"];
    this.descEn = servicePrice["DescEn"];
    this.rangeFrom = servicePrice["RangeFrom"];
    this.rangeTo = servicePrice["RangeTo"];
    this.value = servicePrice["Value"];
  }

  ServicePrice.from(Map<dynamic, dynamic> servicePrice){
    this._servicePriceMapToList(servicePrice);
  }

  static List<ServicePrice> fromListMap(List<dynamic> servicePriceList){
    List<ServicePrice> servicePrices = List();
    servicePriceList.forEach(
      (price) {
          servicePrices.add(ServicePrice().._servicePriceMapToList(price));
      }
    );
    return servicePrices;
  }
}