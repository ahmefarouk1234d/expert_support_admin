import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/Models/offer_status.dart';

class OfferInfo {
  String? offerID;
  String? serviceCategoryID;
  String? serviceTypeID;
  String? mainServiceID;
  String? subMainServiceID;
  String? servNameAr;
  String? servNameEn;
  String? offerTitleAr;
  String? offerTitleEn;
  String? offerDescAr;
  String? offerDescEn;
  String? price;
  String? qauntity;
  String? dateCreate;
  num? dateCreateTimestamp;
  String? dateUpdate;
  num? dateUpdateTimestamp;
  bool? isActive;
  num? startDate;
  num? endDate;

  OfferInfo(
      {this.serviceCategoryID,
      this.serviceTypeID,
      this.mainServiceID,
      this.subMainServiceID,
      this.offerID,
      this.servNameAr,
      this.servNameEn,
      this.offerTitleAr,
      this.offerTitleEn,
      this.offerDescAr,
      this.offerDescEn,
      this.price,
      this.qauntity,
      this.dateCreate,
      this.dateUpdate,
      this.startDate,
      this.endDate,
      this.isActive});

  //DateConvert().toStringFromTimestamp(timestamp: dateCreated)

  void _offerMapToList(DocumentSnapshot offerDocData) {
    Map<String, dynamic> offerData = offerDocData.data() as Map<String, dynamic>;
    num dateCreate = offerData["dateCreate"];
    num dateUpdate = offerData["dateUpdate"];

    offerID = offerDocData.id;
    serviceCategoryID = offerData["serviceCategoryID"];
    serviceTypeID = offerData["serviceTypeID"];
    mainServiceID = offerData["mainServiceID"];
    subMainServiceID = offerData["subMainServiceID"];
    servNameAr = offerData["serviceNameAr"];
    servNameEn = offerData["serviceNameEn"];
    offerTitleAr = offerData["offerTitleAr"];
    offerTitleEn = offerData["offerTitleEn"];
    offerDescAr = offerData["offerDescAr"];
    offerDescEn = offerData["offerDescEn"];
    price = offerData["price"];
    qauntity = offerData["qauntity"];
    this.dateCreate = DateConvert()
        .toStringFromTimestamp(timestamp: dateCreate.toInt(), isFull: true);
    dateCreateTimestamp = dateCreate;
    this.dateUpdate = DateConvert()
        .toStringFromTimestamp(timestamp: dateUpdate.toInt(), isFull: true);
    dateUpdateTimestamp = dateUpdate;
    isActive = offerData["isActive"];
    startDate = offerData["startDate"];
    endDate = offerData["endDate"];
  }

  OfferInfo.fromMap(DocumentSnapshot offerDocData) {
    _offerMapToList(offerDocData);
  }

  static List<OfferInfo> fromMapList(
      {required List<DocumentSnapshot> offerDocDataList}) {
    List<OfferInfo> offerList = <OfferInfo>[];
    for (var offerDocData in offerDocDataList) {
      offerList.add(OfferInfo().._offerMapToList(offerDocData));
    }
    return offerList;
  }

  Map<String, dynamic> toMapOnCreate(OfferInfo offer) {
    return {
      "serviceCategoryID": offer.serviceCategoryID,
      "serviceTypeID": offer.serviceTypeID,
      "mainServiceID": offer.mainServiceID,
      "subMainServiceID": offer.subMainServiceID,
      "serviceNameAr": offer.servNameAr,
      "serviceNameEn": offer.servNameEn,
      "offerTitleAr": offer.offerTitleAr,
      "offerTitleEn": offer.offerTitleEn,
      "offerDescAr": offer.offerDescAr,
      "offerDescEn": offer.offerDescEn,
      "price": offer.price,
      "qauntity": offer.qauntity,
      "dateCreate": DateTime.now().toUtc().millisecondsSinceEpoch,
      "dateUpdate": DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive": true,
      "startDate": offer.startDate ?? 0,
      "endDate": offer.endDate ?? 0,
    };
  }

  Map<String, dynamic> toMapOnUpdateAll(OfferInfo offer) {
    return {
      "offerTitleAr": offer.offerTitleAr,
      "offerTitleEn": offer.offerTitleEn,
      "offerDescAr": offer.offerDescAr,
      "offerDescEn": offer.offerDescEn,
      "price": offer.price,
      "qauntity": offer.qauntity,
      "dateUpdate": DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive": offer.isActive,
      "startDate": offer.startDate ?? 0,
      "endDate": offer.endDate ?? 0,
    };
  }

  Map<String, dynamic> toMapOnUpdateStatus(OfferInfo offer) {
    return {
      "dateUpdate": DateTime.now().toUtc().millisecondsSinceEpoch,
      "isActive": offer.isActive,
      "startDate": offer.startDate ?? 0,
      "endDate": offer.endDate ?? 0,
    };
  }
}

class OrderOfferInfo {
  String? id;
  String? serviceCategoryID;
  String? serviceTypeID;
  String? mainServiceID;
  String? subMainServiceID;
  String? titleAr;
  String? titleEn;
  String? descAr;
  String? descEn;
  num? priceForOne;
  num? qauntity;
  String? dateCreate;
  num? dateCreateTimestamp;
  String? dateUpdate;
  num? dateUpdateTimestamp;
  String? status;
  num? startDate;
  num? endDate;
  num? originalPrice;
  String? serviceDetailsAr;
  String? serviceDetailsEn;
  String? offerType;

  OrderOfferInfo(
      {this.dateUpdateTimestamp,
      this.titleAr,
      this.dateCreate,
      this.dateCreateTimestamp,
      this.dateUpdate,
      this.endDate,
      this.status,
      this.descAr,
      this.descEn,
      this.id,
      this.titleEn,
      this.priceForOne,
      this.qauntity,
      this.startDate,
      this.serviceCategoryID,
      this.serviceTypeID,
      this.mainServiceID,
      this.subMainServiceID,
      this.originalPrice,
      this.serviceDetailsAr,
      this.serviceDetailsEn,
      this.offerType});

  void _fromMapToObject(DocumentSnapshot offerDocData) {
    Map<String, dynamic> offerData = offerDocData.data() as Map<String, dynamic>;
    num dateCreate = offerData["date_create"];
    num dateUpdate = offerData["date_update"];

    id = offerDocData.id;
    serviceCategoryID = offerData["service_category_id"];
    serviceTypeID = offerData["service_type_id"];
    mainServiceID = offerData["main_service_id"];
    subMainServiceID = offerData["sub_main_service_id"];
    titleAr = offerData["offer_title_ar"];
    titleEn = offerData["offer_title_en"];
    descAr = offerData["offer_desc_ar"];
    descEn = offerData["offer_desc_en"];
    priceForOne = offerData["price"];
    qauntity = offerData["qauntity"];
    this.dateCreate = DateConvert()
        .toStringFromTimestamp(timestamp: dateCreate.toInt(), isFull: true);
    dateCreateTimestamp = dateCreate;
    this.dateUpdate = DateConvert()
        .toStringFromTimestamp(timestamp: dateUpdate.toInt(), isFull: true);
    dateUpdateTimestamp = dateUpdate;
    status = offerData["status"];
    startDate = offerData["start_date"];
    endDate = offerData["end_date"];
    originalPrice = offerData["original_price"];
    serviceDetailsAr = offerData["service_details_ar"];
    serviceDetailsEn = offerData["service_details_en"];
    offerType = offerData["offer_type"];
  }

  OrderOfferInfo.fromMap(DocumentSnapshot offerDocData) {
    _fromMapToObject(offerDocData);
  }

  static List<OrderOfferInfo> fromMapList(
      {required List<DocumentSnapshot> offerDocDataList}) {
    List<OrderOfferInfo> offerList = <OrderOfferInfo>[];
    for (var offerDocData in offerDocDataList) {
      offerList.add(OrderOfferInfo().._fromMapToObject(offerDocData));
    }
    return offerList;
  }

  Map<String, dynamic> toMapOnCreate(OrderOfferInfo offer) {
    return {
      "service_category_id": offer.serviceCategoryID,
      "service_type_id": offer.serviceTypeID,
      "main_service_id": offer.mainServiceID,
      "sub_main_service_id": offer.subMainServiceID,
      "offer_title_ar": offer.titleAr,
      "offer_title_en": offer.titleEn,
      "offer_desc_ar": offer.descAr,
      "offer_desc_en": offer.descEn,
      "price": offer.priceForOne,
      "qauntity": offer.qauntity,
      "date_create": DateTime.now().toUtc().millisecondsSinceEpoch,
      "date_update": DateTime.now().toUtc().millisecondsSinceEpoch,
      "status": OfferStatus.active,
      "start_date": offer.startDate ?? 0,
      "end_date": offer.endDate ?? 0,
      "original_price": offer.originalPrice,
      "service_details_ar": offer.serviceDetailsAr,
      "service_details_en": offer.serviceDetailsEn,
      "offer_type": offer.offerType,
    };
  }

  Map<String, dynamic> toMapOnUpdateAll(OrderOfferInfo offer) {
    return {
      "offer_title_ar": offer.titleAr,
      "offer_title_en": offer.titleEn,
      "offer_desc_ar": offer.descAr,
      "offer_desc_en": offer.descEn,
      "price": offer.priceForOne,
      "qauntity": offer.qauntity,
      "date_update": DateTime.now().toUtc().millisecondsSinceEpoch,
      "status": offer.status,
      "start_date": offer.startDate ?? 0,
      "end_date": offer.endDate ?? 0,
      "service_details_ar": offer.serviceDetailsAr,
      "service_details_en": offer.serviceDetailsEn,
    };
  }

  Map<String, dynamic> toMapOnUpdateStatus(OrderOfferInfo offer) {
    return {
      "date_update": DateTime.now().toUtc().millisecondsSinceEpoch,
      "status": offer.status,
      "start_date": offer.startDate ?? 0,
      "end_date": offer.endDate ?? 0,
    };
  }
}
