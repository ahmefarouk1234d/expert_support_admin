import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/Models/offer_status.dart';

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
    this.dateCreate = DateConvert().toStringFromTimestamp(timestamp: dateCreate, isFull: true);
    this.dateCreateTimestamp = dateCreate;
    this.dateUpdate = DateConvert().toStringFromTimestamp(timestamp: dateUpdate, isFull: true);
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
  String status;
  num startDate;
  num endDate;
  num originalPrice;

  OrderOfferInfo({
    this.dateUpdateTimestamp, this.titleAr, this.dateCreate, this.dateCreateTimestamp, this.dateUpdate, this.endDate, this.status, this.descAr, this.descEn, this.id, this.titleEn, this.priceForOne, this.qauntity, this.startDate, this.serviceCategoryID, this.serviceTypeID, this.mainServiceID, this.subMainServiceID, this.originalPrice
  });

  _fromMapToObject(DocumentSnapshot offerDocData){
    Map<String, dynamic> offerData = offerDocData.data;
    num dateCreate = offerData["date_create"];
    num dateUpdate = offerData["date_update"];

    this.id = offerDocData.documentID;
    this.serviceCategoryID = offerData["service_category_id"];
    this.serviceTypeID = offerData["service_type_id"];
    this.mainServiceID = offerData["main_service_id"];
    this.subMainServiceID = offerData["sub_main_service_id"];
    this.titleAr = offerData["offer_title_ar"];
    this.titleEn = offerData["offer_title_en"];
    this.descAr = offerData["offer_desc_ar"];
    this.descEn = offerData["offer_desc_en"];
    this.priceForOne = offerData["price"];
    this.qauntity = offerData["qauntity"];
    this.dateCreate = DateConvert().toStringFromTimestamp(timestamp: dateCreate, isFull: true);
    this.dateCreateTimestamp = dateCreate;
    this.dateUpdate = DateConvert().toStringFromTimestamp(timestamp: dateUpdate, isFull: true);
    this.dateUpdateTimestamp = dateUpdate;
    this.status = offerData["status"];
    this.startDate = offerData["start_date"];
    this.endDate = offerData["end_date"];
    this.originalPrice = offerData["original_price"];
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
      "service_category_id" : offer.serviceCategoryID,
      "service_type_id": offer.serviceTypeID,
      "main_service_id" : offer.mainServiceID,
      "sub_main_service_id" : offer.subMainServiceID,
      "offer_title_ar" : offer.titleAr,
      "offer_title_en" : offer.titleEn,
      "offer_desc_ar" : offer.descAr,
      "offer_desc_en" : offer.descEn,
      "price" : offer.priceForOne,
      "qauntity" : offer.qauntity,
      "date_create" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "date_update" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "status" : OfferStatus.active,
      "start_date" : offer.startDate ?? 0,
      "end_date" : offer.endDate ?? 0,
      "original_price": offer.originalPrice
    };
  }

  Map<String, dynamic> toMapOnUpdateAll(OrderOfferInfo offer){
    return {
      "offer_title_ar" : offer.titleAr,
      "offer_title_en" : offer.titleEn,
      "offer_desc_ar" : offer.descAr,
      "offer_desc_en" : offer.descEn,
      "price" : offer.priceForOne,
      "qauntity" : offer.qauntity,
      "date_update" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "status" : offer.status,
      "start_date" : offer.startDate ?? 0,
      "end_date" : offer.endDate ?? 0,
    };
  }

  Map<String, dynamic> toMapOnUpdateStatus(OrderOfferInfo offer){
    return {
      "date_update" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "status" : offer.status,
      "start_date" : offer.startDate ?? 0,
      "end_date" : offer.endDate ?? 0,
    };
  }
}