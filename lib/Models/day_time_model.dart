import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:flutter/material.dart';

class DayTime{
  // ---------------- DayTime to display ----------------------
  static const String eveningEn = "Evening";
  static const String eveningAr = "مساء";
  static const String morningEn = "Morning";
  static const String morningAr = "صباح";
  static const String unknownAr = "وقت غير معروفة";
  static const String unknownEn = "Unknow Time";

  // ---------------- database DayTime -------------------------
  static const String evening = "Evening";
  static const String morning = "Morning";
  static const String unknown = "unknow";

  String getDisplayStatus({required String dayTime, required BuildContext context}) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    switch (dayTime) {
      case evening:
        return isArabic ? eveningAr : eveningEn;
      case morning:
        return isArabic ? morningAr : morningEn;
      default:
        return dayTime;
    }
  }

  String getTimeOfDayDB({required DayPeriod period}) {
    switch (period) {
      case DayPeriod.am:
        return morning;
      case DayPeriod.pm:
        return evening;
      default:
        return unknown;
    }
  }
}