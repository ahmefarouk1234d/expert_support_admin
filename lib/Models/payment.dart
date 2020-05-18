import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:flutter/material.dart';

class Payment {
  static const String cash = "Cash";
  static const String pos = "POS";

  static const String cashEn = "Cash";
  static const String cashAr = "كاش";
  static const String posEn = "Pay via Point of Sales device";
  static const String posAr = "جهاز شبكة - نقاط البيع";
  static const String unknownAr = "غير معروفة";
  static const String unknownEn = "Unknow";

  String getDisplayStatus({@required String status, @required BuildContext context}) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    switch (status) {
      case cash:
        return isArabic ? cashAr : cashEn;
      case pos:
        return isArabic ? posAr : posEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}