import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';

class DiscountInfo {
  String? id;
  String? code;
  bool? isValid;
  int? percent;
  String? dateCreate;
  num? dateCreateTimestamp;
  String? dateUpdate;
  num? dateUpdateTimestamp;

  DiscountInfo(
      {this.id,
      this.code,
      this.isValid,
      this.percent,
      this.dateCreate,
      this.dateCreateTimestamp,
      this.dateUpdate,
      this.dateUpdateTimestamp});

  void _fromMapToObject(DocumentSnapshot offerDocData) {
    Map<String, dynamic> offerData = offerDocData.data() as Map<String, dynamic>;
    num dateCreate = offerData["date_create"];
    num dateUpdate = offerData["date_update"];

    id = offerDocData.id;
    code = offerData["code"];
    isValid = offerData["is_valid"];
    percent = offerData["percent"];
    this.dateCreate = DateConvert()
        .toStringFromTimestamp(timestamp: dateCreate.toInt(), isFull: true);
    dateCreateTimestamp = dateCreate;
    this.dateUpdate = DateConvert()
        .toStringFromTimestamp(timestamp: dateUpdate.toInt(), isFull: true);
    dateUpdateTimestamp = dateUpdate;
  }

  DiscountInfo.fromMap(DocumentSnapshot discountDocData) {
    _fromMapToObject(discountDocData);
  }

  static List<DiscountInfo> fromMapList(
      {required List<DocumentSnapshot> discountDocDataList}) {
    List<DiscountInfo> discountList = <DiscountInfo>[];
    for (var discountDocData in discountDocDataList) {
      discountList.add(DiscountInfo().._fromMapToObject(discountDocData));
    }
    return discountList;
  }

  Map<String, dynamic> toMapOnCreate(DiscountInfo discountInfo) {
    return {
      "code": discountInfo.code,
      "is_valid": discountInfo.isValid,
      "percent": discountInfo.percent,
      "date_create": DateTime.now().toUtc().millisecondsSinceEpoch,
      "date_update": DateTime.now().toUtc().millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toMapOnUpdateStatus(DiscountInfo discountInfo) {
    return {
      "date_update": DateTime.now().toUtc().millisecondsSinceEpoch,
      "is_valid": discountInfo.isValid
    };
  }
}
