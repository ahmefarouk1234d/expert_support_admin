import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:flutter/material.dart';

class GeneralDetailsModel {
  GeneralDetailsType? type;
  AboutUs? aboutUs;
  Shared? shared;
  SubmitOrder? submitOrder;
  OrderLimit? orderLimit;

  GeneralDetailsModel();

  void _fromDocumentSnapshotToObject(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    switch (doc.id) {
      case "ContactUs":
        aboutUs = AboutUs.fromMap(data);
        type = GeneralDetailsType.contactUs;
        break;

      case "Shared":
        shared = Shared.fromMap(data);
        type = GeneralDetailsType.shared;
        break;

      case "SubmitOrder":
        submitOrder = SubmitOrder.fromMap(data);
        type = GeneralDetailsType.submitOrder;
        break;

      case "orderLimit":
        orderLimit = OrderLimit.fromMap(data);
        type = GeneralDetailsType.orderLimit;
        break;

      default:
        break;
    }
  }

  GeneralDetailsModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    _fromDocumentSnapshotToObject(doc);
  }

  static List<GeneralDetailsModel> fromDocumentSnapshotList(
      {required List<DocumentSnapshot> docList}) {
    List<GeneralDetailsModel> detailList = <GeneralDetailsModel>[];
    for (var doc in docList) {
      detailList.add(GeneralDetailsModel().._fromDocumentSnapshotToObject(doc));
    }
    return detailList;
  }

  static String getDisplayType(GeneralDetailsType type, BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    String diplayType = "";

    switch (type) {
      case GeneralDetailsType.contactUs:
        diplayType = localizations.translate(LocalizedKey.aboutUsItemTitle);
        break;
      case GeneralDetailsType.shared:
        diplayType = localizations.translate(LocalizedKey.sharedItemTitle);
        break;
      case GeneralDetailsType.submitOrder:
        diplayType = localizations.translate(LocalizedKey.submitOrderItemTitle);
        break;
      case GeneralDetailsType.orderLimit:
        diplayType = localizations.translate(LocalizedKey.orderLimitItemTitle);
        break;
      default:
        diplayType = "unknow type";
        break;
    }

    return diplayType;
  }
}

class AboutUs {
  String? headerAr;
  String? headerEn;
  String? aboutUsAr;
  String? aboutUsEn;
  String? phone;
  String? twitter;
  String? instagram;
  String? facebook;

  AboutUs();

  void _fromMapToObject(Map<String, dynamic> data) {
    headerAr = data["header_ar"];
    headerEn = data["header_en"];
    aboutUsAr = data["about_us_ar"];
    aboutUsEn = data["about_us_en"];
    phone = data["phone"];
    twitter = data["twitter"];
    instagram = data["instagram"];
    facebook = data["facebook"];
  }

  AboutUs.fromMap(Map<String, dynamic> data) {
    _fromMapToObject(data);
  }

  static List<AboutUs> fromMapList({required List<dynamic> dataList}) {
    List<AboutUs> list = <AboutUs>[];
    for (var data in dataList) {
      list.add(AboutUs().._fromMapToObject(data));
    }
    return list;
  }

  Map<String, dynamic> toMapOnUpdate(AboutUs aboutUs) {
    return {
      "header_ar": aboutUs.headerAr,
      "header_en": aboutUs.headerEn,
      "about_us_ar": aboutUs.aboutUsAr,
      "about_us_en": aboutUs.aboutUsEn,
      "phone": aboutUs.phone,
      "twitter": aboutUs.twitter,
      "instagram": aboutUs.instagram,
      "facebook": aboutUs.facebook,
    };
  }
}

class Shared {
  String? link;
  String? linkAndroid;

  Shared();

  void _fromMapToObject(Map<String, dynamic> data) {
    link = data["link"];
    linkAndroid = data["link_android"];
  }

  Shared.fromMap(Map<String, dynamic> data) {
    _fromMapToObject(data);
  }

  static List<Shared> fromMapList({required List<dynamic> dataList}) {
    List<Shared> list = <Shared>[];
    for (var data in dataList) {
      list.add(Shared().._fromMapToObject(data));
    }
    return list;
  }

  Map<String, dynamic> toMapOnUpdate(Shared shared) {
    return {"link": shared.link, "link_android": shared.linkAndroid};
  }
}

class SubmitOrder {
  List<TermsAndConditions>? termsAndConditions;
  num? limitRate;
  bool? isCashEnabled;
  bool? isPOSEnabled;
  num? vatPercentage;
  String? vatPriceNoteAr;
  String? vatPriceNoteEn;
  bool? canShowVatNote;

  SubmitOrder();

  void _fromDocumentSnapshotToObject(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    termsAndConditions =
        TermsAndConditions.fromMapList(dataList: data["TermsConditions"]);
    limitRate = data["limit_rate"];
    isCashEnabled = data["is_cash_enabled"];
    isPOSEnabled = data["is_pos_enabled"];
    vatPercentage = data["VAT_percentage"];
    vatPriceNoteAr = data["vat_price_note_ar"];
    vatPriceNoteEn = data["vat_price_note_en"];
    canShowVatNote = data["can_show_vat_note"];
  }

  SubmitOrder.fromDocumentSnapshot(DocumentSnapshot doc) {
    _fromDocumentSnapshotToObject(doc);
  }

  void _fromMapToObject(Map<String, dynamic> data) {
    termsAndConditions =
        TermsAndConditions.fromMapList(dataList: data["TermsConditions"]);
    limitRate = data["limit_rate"];
    isCashEnabled = data["is_cash_enabled"];
    isPOSEnabled = data["is_pos_enabled"];
    vatPercentage = data["VAT_percentage"];
    vatPriceNoteAr = data["vat_price_note_ar"];
    vatPriceNoteEn = data["vat_price_note_en"];
    canShowVatNote = data["can_show_vat_note"];
  }

  SubmitOrder.fromMap(Map<String, dynamic> data) {
    _fromMapToObject(data);
  }

  static List<SubmitOrder> fromMapList({required List<dynamic> dataList}) {
    List<SubmitOrder> list = <SubmitOrder>[];
    for (var data in dataList) {
      list.add(SubmitOrder().._fromMapToObject(data));
    }
    return list;
  }

  Map<String, dynamic> toMapOnUpdate(SubmitOrder submitOrder) {
    return {
      "limit_rate": submitOrder.limitRate,
      "is_cash_enabled": submitOrder.isCashEnabled,
      "is_pos_enabled": submitOrder.isPOSEnabled,
      "VAT_percentage": submitOrder.vatPercentage,
      "vat_price_note_ar": submitOrder.vatPriceNoteAr,
      "vat_price_note_en": submitOrder.vatPriceNoteEn,
      "can_show_vat_note": submitOrder.canShowVatNote
    };
  }
}

class TermsAndConditions {
  String? textAr;
  String? textEn;

  TermsAndConditions();

  void _fromMapToObject(Map<String, dynamic> data) {
    textAr = data["text_ar"];
    textEn = data["text_en"];
  }

  TermsAndConditions.fromMap(Map<String, dynamic> data) {
    _fromMapToObject(data);
  }

  static List<TermsAndConditions> fromMapList(
      {required List<dynamic> dataList}) {
    List<TermsAndConditions> list = <TermsAndConditions>[];
    for (var data in dataList) {
      list.add(TermsAndConditions().._fromMapToObject(data));
    }
    return list;
  }
}

class OrderLimit {
  int? perDay;
  int? unavaliableStartDateTimestamp;
  int? unavaliableEndDateTimestamp;

  OrderLimit();

  void _fromMapToObject(Map<String, dynamic> data) {
    perDay = data["per_day"];
    unavaliableStartDateTimestamp = data["unavailable_start_date"];
    unavaliableEndDateTimestamp = data["unavailable_end_date"];
  }

  OrderLimit.fromMap(Map<String, dynamic> data) {
    _fromMapToObject(data);
  }

  static List<OrderLimit> fromMapList({required List<dynamic> dataList}) {
    List<OrderLimit> list = <OrderLimit>[];
    for (var data in dataList) {
      list.add(OrderLimit().._fromMapToObject(data));
    }
    return list;
  }

  Map<String, dynamic> toMapOnUpdate(OrderLimit orderLimit) {
    return {
      "per_day": orderLimit.perDay,
      "unavailable_start_date": orderLimit.unavaliableStartDateTimestamp,
      "unavailable_end_date": orderLimit.unavaliableEndDateTimestamp
    };
  }
}
