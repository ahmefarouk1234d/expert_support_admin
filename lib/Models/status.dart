import 'package:flutter/cupertino.dart';

class Status {
  // ---------------- status to display ----------------------
  static const String inProcessEn = "In process";
  static const String inProcessAr = "تحت المعالجة";
  static const String doneEn = "Done";
  static const String doneAr = "منحز";
  static const String canceledEn = "Canceled";
  static const String canceledAr = "ملغى";
  static const String pendingEn = "Pending";
  static const String pendingAr = "معلق";
  static const String unknownAr = "حالة غير معروفة";
  static const String unknownEn = "Unknow Status";

  // ---------------- actual status -------------------------
  static const String inProcess = "InProcess";
  static const String done = "Done";
  static const String pending = "Pending";
  static const String canceled = "Canceled";
  static const String unknown = "unknow";

  String getDisplayStaus({@required String status}) {
    switch (status) {
      case inProcess:
        return inProcessEn;
      case pending:
        return pendingEn;
      case done:
        return doneEn;
      case canceled:
        return canceledEn;
      default:
        return unknownEn;
    }
  }
}
