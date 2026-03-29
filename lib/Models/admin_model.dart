import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:flutter/material.dart';

class AdminUserStatus {
  // ---------------- Database status ----------------------
  static const String active = "active";
  static const String deleted = "deleted";
  static const String disbaled = "disabled";
  static const String unknown = "unknow";

  // ---------------- status to display ----------------------
  static const String activeEn = "Active";
  static const String activeAr = "نشط";
  static const String deletedEn = "Deleted";
  static const String deletedAr = "محذوف";
  static const String disbaledEn = "Disabled";
  static const String disbaledAr = "معطل";
  static const String unknownEn = "Unknow Status";
  static const String unknownAr = "حالة غير معروفة";

  String getDisplayStatus(
      {required String status, required BuildContext context}) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    switch (status) {
      case active:
        return isArabic ? activeAr : activeEn;
      case deleted:
        return isArabic ? deletedAr : deletedEn;
      case disbaled:
        return isArabic ? disbaledAr : disbaledEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}

class AdminUserInfo {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? role;
  String? fcmToken;
  String? status;
  int? dateCreated;
  int? dateUpdated;

  AdminUserInfo(
      {this.id,
      this.email,
      this.role,
      this.fcmToken,
      this.name,
      this.phone,
      this.dateCreated,
      this.dateUpdated,
      this.status});

  void _userMapToList(DocumentSnapshot adminDocData) {
    Map<String, dynamic> adminData = adminDocData.data() as Map<String, dynamic>;
    id = adminDocData.id;
    email = adminData["email"];
    role = adminData["role"];
    fcmToken = adminData["fcm_token"];
    name = adminData["name"];
    phone = adminData["phone"];
    status = adminData["status"];
    dateCreated = adminData["date_created"];
    dateUpdated = adminData["date_updated"];
  }

  AdminUserInfo.fromMap(DocumentSnapshot adminDocData) {
    _userMapToList(adminDocData);
  }

  static List<AdminUserInfo> fromMapList(
      {required List<DocumentSnapshot> adminDocDataList}) {
    List<AdminUserInfo> aminList = <AdminUserInfo>[];
    for (var adminDocData in adminDocDataList) {
      aminList.add(AdminUserInfo().._userMapToList(adminDocData));
    }
    return aminList;
  }

  Map<String, dynamic> toMap(AdminUserInfo admin) {
    return {
      "name": admin.name,
      "phone": admin.phone,
      "email": admin.email,
      "role": admin.role,
      "fcm_token": admin.fcmToken,
      "status": admin.status,
      "date_created": admin.dateCreated,
      "date_updated": admin.dateUpdated,
    };
  }

  Map<String, dynamic> toUpdateInfoMap(AdminUserInfo admin) {
    return {
      "name": admin.name,
      "phone": admin.phone,
      "email": admin.email,
      "role": admin.role,
      "date_updated": admin.dateUpdated,
    };
  }

  Map<String, dynamic> toDeletedInfoMap(AdminUserInfo admin) {
    return {
      "status": admin.status,
      "date_updated": admin.dateUpdated,
    };
  }

  void update(AdminUserInfo admin) {
    id = admin.id;
    email = admin.email;
    role = admin.role;
    fcmToken = admin.fcmToken;
    name = admin.name;
    phone = admin.phone;
    status = admin.status;
    dateCreated = admin.dateCreated;
    dateUpdated = admin.dateUpdated;
  }
}

//DateTime.now().toUtc().millisecondsSinceEpoch
