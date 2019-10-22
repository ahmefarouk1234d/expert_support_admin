import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class OrderStatus {
  // ---------------- status to display ----------------------
  static const String inProcessEn = "In process";
  static const String inProcessAr = "تحت المعالجة";
  static const String doneEn = "Done";
  static const String doneAr = "منجز";
  static const String canceledEn = "Canceled";
  static const String canceledAr = "ملغي";
  static const String pendingEn = "Pending";
  static const String pendingAr = "معلق";
  static const String requestChangeEn = "Request Change";
  static const String requestChangeAr = "طلب تعديل";
  static const String unknownAr = "حالة غير معروفة";
  static const String unknownEn = "Unknow Status";

  // ---------------- database status -------------------------
  static const String inProcess = "InProcess";
  static const String done = "Done";
  static const String pending = "Pending";
  static const String canceled = "Canceled";
  static const String requestChange = "RequestChange";
  static const String unknown = "unknow";

  String getDisplayStatus({@required String status, @required BuildContext context}) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    switch (status) {
      case inProcess:
        return isArabic ? inProcessAr : inProcessEn;
      case pending:
        return isArabic ? pendingAr : pendingEn;
      case done:
        return isArabic ? doneAr : doneEn;
      case canceled:
        return isArabic ? canceledAr : canceledEn;
      case requestChange:
        return isArabic ? requestChangeAr : requestChangeEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}
