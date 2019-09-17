import 'package:flutter/material.dart';

class OfferStatus{
  static const String active = "active";
  static const String deactive = "deactive";
  static const String unknown = "unknow";

  static const String activeAr = "نشط";
  static const String activeEn = "Active";
  static const String deactiveAr = "غير نشط";
  static const String deactiveEn = "Deactive";
  static const String unknownAr = "حالة غير معروفة";
  static const String unknownEn = "Unknow Status";

  String getDisplayStaus({@required String status}) {
    switch (status) {
      case active:
        return activeEn;
      case deactive:
        return deactiveEn;
      default:
        return unknownEn;
    }
  }
}