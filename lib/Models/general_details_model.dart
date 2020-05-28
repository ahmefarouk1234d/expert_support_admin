import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum GeneralDetailsType {
  contactUs,
  shared,
  submitOrder,
  orderLimit
}

class GeneralDetails {
  AboutUs aboutUs;
  Shared shared;
  SubmitOrder submitOrder;
  OrderLimit orderLimit;

  GeneralDetails();

  _fromDocumentSnapshotToObject(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data;

    switch (doc.documentID) {
      case "ContactUs":
        this.aboutUs = AboutUs.fromMap(data);
        break;

      case "Shared":
        this.shared = Shared.fromMap(data);
        break;

      case "SubmitOrder":
        this.submitOrder = SubmitOrder.fromMap(data);
        break;

      case "orderLimit":
        this.orderLimit = OrderLimit.fromMap(data);
        break;

      default:
        break;
    }
  }

  GeneralDetails.fromDocumentSnapshot(DocumentSnapshot doc){
    this._fromDocumentSnapshotToObject(doc);
  }

  static GeneralDetails fromDocumentSnapshotList({@required List<DocumentSnapshot> docList}){
    GeneralDetails details = GeneralDetails();
    docList.forEach((doc) {
      details._fromDocumentSnapshotToObject(doc);
    });
    return details;
  }
}

class AboutUs {
  String headerAr;
  String headerEn;
  String aboutUsAr;
  String aboutUsEn;
  String phone;
  String twitter;
  String instagram;
  String facebook;

  AboutUs();

  _fromMapToObject(Map<dynamic, dynamic> data){
    this.headerAr = data["header_ar"];
    this.headerEn = data["header_en"];
    this.aboutUsAr = data["about_us_ar"];
    this.aboutUsEn = data["about_us_en"];
    this.phone = data["phone"];
    this.twitter = data["twitter"];
    this.instagram = data["instagram"];
    this.facebook = data["facebook"];
  }

  AboutUs.fromMap(Map<dynamic, dynamic> data){
    this._fromMapToObject(data);
  }

  static List<AboutUs> fromMapList({@required List<dynamic> dataList}){
    List<AboutUs> list = List();
    dataList.forEach((data) => list.add(AboutUs().._fromMapToObject(data)));
    return list;
  }
}

class Shared {
  String link;
  String linkAndroid;

  Shared();

  _fromMapToObject(Map<dynamic, dynamic> data){
    this.link = data["link"];
    this.linkAndroid = data["link_android"];
  }

  Shared.fromMap(Map<dynamic, dynamic> data){
    this._fromMapToObject(data);
  }

  static List<Shared> fromMapList({@required List<dynamic> dataList}){
    List<Shared> list = List();
    dataList.forEach((data) => list.add(Shared().._fromMapToObject(data)));
    return list;
  }
}

class SubmitOrder {
  List<TermsAndConditions> termsAndConditions;
  num limitRate;
  bool isCashEnabled;
  bool isPOSEnabled;
  num vatPercentage;

  SubmitOrder();

  _fromDocumentSnapshotToObject(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data;
    this.termsAndConditions = TermsAndConditions.fromMapList(dataList: data["TermsConditions"]);
    this.limitRate = data["limit_rate"];
    this.isCashEnabled = data["is_cash_enabled"];
    this.isPOSEnabled = data["is_pos_enabled"];
    this.vatPercentage = data["VAT_percentage"];
  }

  SubmitOrder.fromDocumentSnapshot(DocumentSnapshot doc){
    this._fromDocumentSnapshotToObject(doc);
  }

  _fromMapToObject(Map<dynamic, dynamic> data){
    this.termsAndConditions = TermsAndConditions.fromMapList(dataList: data["TermsConditions"]);
    this.limitRate = data["limit_rate"];
    this.isCashEnabled = data["is_cash_enabled"];
    this.isPOSEnabled = data["is_pos_enabled"];
    this.vatPercentage = data["VAT_percentage"];
  }

  SubmitOrder.fromMap(Map<dynamic, dynamic> data){
    this._fromMapToObject(data);
  }

  static List<SubmitOrder> fromMapList({@required List<dynamic> dataList}){
    List<SubmitOrder> list = List();
    dataList.forEach((data) => list.add(SubmitOrder().._fromMapToObject(data)));
    return list;
  }
}

class TermsAndConditions{
  String textAr;
  String textEn;

  TermsAndConditions();

  _fromMapToObject(Map<dynamic, dynamic> data){
    this.textAr = data["text_ar"];
    this.textEn = data["text_en"];
  }

  TermsAndConditions.fromMap(Map<dynamic, dynamic> data){
    this._fromMapToObject(data);
  }

  static List<TermsAndConditions> fromMapList({@required List<dynamic> dataList}){
    List<TermsAndConditions> list = List();
    dataList.forEach((data) => list.add(TermsAndConditions().._fromMapToObject(data)));
    return list;
  }
}

class OrderLimit {
  int perDay;
  int unavaliableStartDateTimestamp;
  int unavaliableEndDateTimestamp;
  
  OrderLimit();

  _fromMapToObject(Map<dynamic, dynamic> data){
    this.perDay = data["per_day"];
    this.unavaliableStartDateTimestamp = data["unavailable_start_date"];
    this.unavaliableEndDateTimestamp = data["unavailable_end_date"];
  }

  OrderLimit.fromMap(Map<dynamic, dynamic> data){
    this._fromMapToObject(data);
  }

  static List<OrderLimit> fromMapList({@required List<dynamic> dataList}){
    List<OrderLimit> list = List();
    dataList.forEach((data) => list.add(OrderLimit().._fromMapToObject(data)));
    return list;
  }
}
