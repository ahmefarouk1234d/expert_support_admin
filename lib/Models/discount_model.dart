import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';

class DiscountInfo {
  String id;
  String code;
  bool isValid;
  int percent;
  String dateCreate;
  num dateCreateTimestamp;
  String dateUpdate;
  num dateUpdateTimestamp;

  DiscountInfo({this.id ,this.code, this.isValid, this.percent, this.dateCreate, this.dateCreateTimestamp, this.dateUpdate, this.dateUpdateTimestamp});

  _fromMapToObject(DocumentSnapshot offerDocData){
    Map<String, dynamic> offerData = offerDocData.data;
    num dateCreate = offerData["date_create"];
    num dateUpdate = offerData["date_update"];

    this.id = offerDocData.documentID;
    this.code = offerData["code"];
    this.isValid = offerData["is_valid"];
    this.percent = offerData["percent"];
    this.dateCreate = DateConvert().toStringFromTimestamp(timestamp: dateCreate);
    this.dateCreateTimestamp = dateCreate;
    this.dateUpdate = DateConvert().toStringFromTimestamp(timestamp: dateUpdate);
    this.dateUpdateTimestamp = dateUpdate;
  }

  DiscountInfo.fromMap(DocumentSnapshot discountDocData){
    this._fromMapToObject(discountDocData);
  }

  static List<DiscountInfo> fromMapList({List<DocumentSnapshot> discountDocDataList}){
    List<DiscountInfo> discountList = List();
    discountDocDataList.forEach((discountDocData){
      discountList.add(DiscountInfo().._fromMapToObject(discountDocData));
    });
    return discountList;
  }

  Map<String, dynamic> toMapOnCreate(DiscountInfo discountInfo){
    return {
      "code" : discountInfo.code,
      "is_valid": discountInfo.isValid,
      "percent" : discountInfo.percent,
      "date_create" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "date_update" : DateTime.now().toUtc().millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toMapOnUpdateStatus(DiscountInfo discountInfo){
    return {
      "date_update" : DateTime.now().toUtc().millisecondsSinceEpoch,
      "is_valid" : discountInfo.isValid
    };
  }
}