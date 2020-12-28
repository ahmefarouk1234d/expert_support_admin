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
  static const String deleteAr = "محذوف";
  static const String deleteEn = "Deleted";
  static const String onTheWayEn = "On The Way";
  static const String onTheWayAr = "في الطريق";
  static const String arrivedEn = "Technician Start Working";
  static const String arrivedAr = "الفني يشوف شغله";
  static const String unknownAr = "حالة غير معروفة";
  static const String unknownEn = "Unknow Status";

  // ---------------- database status -------------------------
  static const String inProcess = "InProcess";
  static const String done = "Done";
  static const String pending = "Pending";
  static const String canceled = "Canceled";
  static const String delete = "Delete";
  static const String onTheWay = "OnTheWay";
  static const String arrived = "Arrived";
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
      case delete:
        return isArabic ? deleteAr : deleteEn;
      case onTheWay:
        return isArabic ? onTheWayAr : onTheWayEn;
      case arrived:
        return isArabic ? arrivedAr : arrivedEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}

class WorkflowStatus {
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
  static const String requestChangeReplyEn = "Request Change Reply";
  static const String requestChangeReplyAr = "الرد على طلب تعديل";
  static const String addNewServiceEn = "Added New Service";
  static const String addNewServiceAr = "اضافة خدمة جديدة";
  static const String deleteAr = "محذوف";
  static const String deleteEn = "Deleted";
  static const String onTheWayEn = "On The Way";
  static const String onTheWayAr = "في الطريق";
  static const String arrivedEn = "Technician Start Working";
  static const String arrivedAr = "الفني يشوف شغله";
  static const String unknownAr = "حالة غير معروفة";
  static const String unknownEn = "Unknow Status";

  // ---------------- database status -------------------------
  static const String inProcess = "InProcess";
  static const String done = "Done";
  static const String pending = "Pending";
  static const String canceled = "Canceled";
  static const String requestChange = "RequestChange";
  static const String requestChangeReply = "RequestChangeReply";
  static const String addNewService = "AddNewService";
  static const String delete = "Delete";
  static const String onTheWay = "OnTheWay";
  static const String arrived = "Arrived";
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
      case requestChangeReply:
        return isArabic ? requestChangeReplyAr : requestChangeReplyEn;
      case addNewService:
        return isArabic ? addNewServiceAr : addNewServiceEn;
      case delete:
        return isArabic ? deleteAr : deleteEn;
      case onTheWay:
        return isArabic ? onTheWayAr : onTheWayEn;
      case arrived:
        return isArabic ? arrivedAr : arrivedEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}