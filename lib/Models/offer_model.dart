import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';

class OfferInfo{
  String offerID;
  String serviceCategoryID;
  String serviceTypeID;
  String mainServiceID;
  String subMainServiceID;
  String servNameAr;
  String servNameEn;
  String offerTitleAr;
  String offerTitleEn;
  String offerDescAr;
  String offerDescEn;
  String price;
  String qauntity;
  String dateCreate;
  num dateCreateTimestamp;
  String dateUpdate;
  num dateUpdateTimestamp;
  bool isActive;
  num startDate;
  num endDate;

  OfferInfo({this.serviceCategoryID, this.serviceTypeID, this.mainServiceID, this.subMainServiceID, this.offerID, this.servNameAr, this.servNameEn, this.offerTitleAr, this.offerTitleEn, this.offerDescAr, this.offerDescEn, this.price, this.qauntity, this.dateCreate, this.dateUpdate, this.startDate, this.endDate, this.isActive});

  //DateConvert().toStringFromTimestamp(timestamp: dateCreated)

  _offerMapToList(DocumentSnapshot offerDocData){
    Map<String, dynamic> offerData = offerDocData.data;
    num dateCreate = offerData["dateCreate"];
    num dateUpdate = offerData["dateUpdate"];

    this.offerID = offerDocData.documentID;
    this.serviceCategoryID = offerData["serviceCategoryID"];
    this.serviceTypeID = offerData["serviceTypeID"];
    this.mainServiceID = offerData["mainServiceID"];
    this.subMainServiceID = offerData["subMainServiceID"];
    this.servNameAr = offerData["serviceNameAr"];
    this.servNameEn = offerData["serviceNameEn"];
    this.offerTitleAr = offerData["offerTitleAr"];
    this.offerTitleEn = offerData["offerTitleEn"];
    this.offerDescAr = offerData["offerDescAr"];
    this.offerDescEn = offerData["offerDescEn"];
    this.price = offerData["price"];
    this.qauntity = offerData["qauntity"];
    this.dateCreate = DateConvert().toStringFromTimestamp(timestamp: dateCreate);
    this.dateCreateTimestamp = dateCreate;
    this.dateUpdate = DateConvert().toStringFromTimestamp(timestamp: dateUpdate);
    this.dateUpdateTimestamp = dateUpdate;
    this.isActive = offerData["isActive"];
    this.startDate = offerData["startDate"];
    this.endDate = offerData["endDate"];
  }

  OfferInfo.fromMap(DocumentSnapshot offerDocData){
    this._offerMapToList(offerDocData);
  }

  static List<OfferInfo> fromMapList({List<DocumentSnapshot> offerDocDataList}){
    List<OfferInfo> offerList = List();
    offerDocDataList.forEach((offerDocData){
      offerList.add(OfferInfo().._offerMapToList(offerDocData));
    });
    return offerList;
  }

  Map<String, dynamic> toMapOnCreate(OfferInfo offer){
    return {
      "serviceCategoryID" : offer.serviceCategoryID,
      "serviceTypeID" : offer.serviceTypeID,
      "mainServiceID" : offer.mainServiceID,
      "subMainServiceID" : offer.subMainServiceID,
      "serviceNameAr" : offer.servNameAr,
      "serviceNameEn" : offer.servNameEn,
      "offerTitleAr" : offer.offerTitleAr,
      "offerTitleEn" : offer.offerTitleEn,
      "offerDescAr" : offer.offerDescAr,
      "offerDescEn" : offer.offerDescEn,
      "price" : offer.price,
      "qauntity" : offer.qauntity,
      "dateCreate" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "dateUpdate" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive" : true,
      "startDate" : offer.startDate ?? 0,
      "endDate" : offer.endDate ?? 0,
    };
  }

  Map<String, dynamic> toMapOnUpdateAll(OfferInfo offer){
    return {
      "offerTitleAr" : offer.offerTitleAr,
      "offerTitleEn" : offer.offerTitleEn,
      "offerDescAr" : offer.offerDescAr,
      "offerDescEn" : offer.offerDescEn,
      "price" : offer.price,
      "qauntity" : offer.qauntity,
      "dateUpdate" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive" : offer.isActive,
      "startDate" : offer.startDate ?? 0,
      "endDate" : offer.endDate ?? 0,
    };
  }

  Map<String, dynamic> toMapOnUpdateStatus(OfferInfo offer){
    return {
      "dateUpdate" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive" : offer.isActive,
      "startDate" : offer.startDate ?? 0,
      "endDate" : offer.endDate ?? 0,
    };
  }
}

class OrderOfferInfo{
  String id;
  String serviceCategoryID;
  String serviceTypeID;
  String mainServiceID;
  String subMainServiceID;
  String titleAr;
  String titleEn;
  String descAr;
  String descEn;
  num priceForOne;
  num qauntity;
  String dateCreate;
  num dateCreateTimestamp;
  String dateUpdate;
  num dateUpdateTimestamp;
  bool isActive;
  num startDate;
  num endDate;

  OrderOfferInfo({
    this.dateUpdateTimestamp, this.titleAr, this.dateCreate, this.dateCreateTimestamp, this.dateUpdate, this.endDate, this.isActive, this.descAr, this.descEn, this.id, this.titleEn, this.priceForOne, this.qauntity, this.startDate, this.serviceCategoryID, this.serviceTypeID, this.mainServiceID, this.subMainServiceID
  });

  _fromMapToObject(DocumentSnapshot offerDocData){
    Map<String, dynamic> offerData = offerDocData.data;
    num dateCreate = offerData["dateCreate"];
    num dateUpdate = offerData["dateUpdate"];

    this.id = offerDocData.documentID;
    this.serviceCategoryID = offerData["serviceCategoryID"];
    this.serviceTypeID = offerData["serviceTypeID"];
    this.mainServiceID = offerData["mainServiceID"];
    this.subMainServiceID = offerData["subMainServiceID"];
    this.titleAr = offerData["offerTitleAr"];
    this.titleEn = offerData["offerTitleEn"];
    this.descAr = offerData["offerDescAr"];
    this.descEn = offerData["offerDescEn"];
    this.priceForOne = offerData["price"];
    this.qauntity = offerData["qauntity"];
    this.dateCreate = DateConvert().toStringFromTimestamp(timestamp: dateCreate);
    this.dateCreateTimestamp = dateCreate;
    this.dateUpdate = DateConvert().toStringFromTimestamp(timestamp: dateUpdate);
    this.dateUpdateTimestamp = dateUpdate;
    this.isActive = offerData["isActive"];
    this.startDate = offerData["startDate"];
    this.endDate = offerData["endDate"];
  }

  OrderOfferInfo.fromMap(DocumentSnapshot offerDocData){
    this._fromMapToObject(offerDocData);
  }

  static List<OrderOfferInfo> fromMapList({List<DocumentSnapshot> offerDocDataList}){
    List<OrderOfferInfo> offerList = List();
    offerDocDataList.forEach((offerDocData){
      offerList.add(OrderOfferInfo().._fromMapToObject(offerDocData));
    });
    return offerList;
  }

  Map<String, dynamic> toMapOnCreate(OrderOfferInfo offer){
    return {
      "serviceCategoryID" : offer.serviceCategoryID,
      "serviceTypeID": offer.serviceTypeID,
      "mainServiceID" : offer.mainServiceID,
      "subMainServiceID" : offer.subMainServiceID,
      "offerTitleAr" : offer.titleAr,
      "offerTitleEn" : offer.titleEn,
      "offerDescAr" : offer.descAr,
      "offerDescEn" : offer.descEn,
      "price" : offer.priceForOne,
      "qauntity" : offer.qauntity,
      "dateCreate" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "dateUpdate" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive" : true,
      "startDate" : offer.startDate ?? 0,
      "endDate" : offer.endDate ?? 0,
    };
  }

  Map<String, dynamic> toMapOnUpdateAll(OrderOfferInfo offer){
    return {
      "offerTitleAr" : offer.titleAr,
      "offerTitleEn" : offer.titleEn,
      "offerDescAr" : offer.descAr,
      "offerDescEn" : offer.descEn,
      "price" : offer.priceForOne,
      "qauntity" : offer.qauntity,
      "dateUpdate" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive" : offer.isActive,
      "startDate" : offer.startDate ?? 0,
      "endDate" : offer.endDate ?? 0,
    };
  }

  Map<String, dynamic> toMapOnUpdateStatus(OrderOfferInfo offer){
    return {
      "dateUpdate" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive" : offer.isActive,
      "startDate" : offer.startDate ?? 0,
      "endDate" : offer.endDate ?? 0,
    };
  }
}