import 'package:expert_support_admin/HelperClass/app_localizations.dart';
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

  String getDisplayStaus({@required String status, @required BuildContext context}) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    switch (status) {
      case active:
        return isArabic ? activeAr : activeEn;
      case deactive:
        return isArabic ? deactiveAr : deactiveEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}