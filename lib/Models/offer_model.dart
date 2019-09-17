import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';

class OfferInfo{
  String offerID;
  String servID;
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

  OfferInfo({this.servID, this.offerID, this.servNameAr, this.servNameEn, this.offerTitleAr, this.offerTitleEn, this.offerDescAr, this.offerDescEn, this.price, this.qauntity, this.dateCreate, this.dateUpdate, this.startDate, this.endDate, this.isActive});

  //DateConvert().toStringFromTimestamp(timestamp: dateCreated)

  _offerMapToList(DocumentSnapshot offerDocData){
    Map<String, dynamic> offerData = offerDocData.data;
    num dateCreate = offerData["dateCreate"];
    num dateUpdate = offerData["dateUpdate"];

    this.offerID = offerDocData.documentID;
    this.servID = offerData["serviceID"];
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
      "serviceID" : offer.servID,
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