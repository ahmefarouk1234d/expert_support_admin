import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:flutter/material.dart';

class AdminRole{
  // --------------------- displayed role -------------------
  static const String customerServiceEn = "Customer Service";
  static const String customerServiceAr = "خدمة عملاء";
  static const String technicionEn = "Technician";
  static const String technicionAr = "فني";
  static const String accountantEn = "Accountant";
  static const String accountantAr = "محاسب";
  static const String supervisorEn = "Supervisor";
  static const String supervisorAr = "مشرف";
  static const String adminEn = "Admin" ;
  static const String adminAr = "مدير" ;
  static const String unknownAr = "دور غير معروفة";
  static const String unknownEn = "Unknow Role";

  // --------------------- database role --------------------
  static const String customerService = "customer_service";
  static const String technicion = "technician";
  static const String accountant = "accountant";
  static const String supervisor = "supervisor";
  static const String admin = "admin" ;
  static const String unknown = "unknow";

  String getDisplayRole({required String role, required BuildContext context}) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    switch (role) {
      case customerService:
        return isArabic ? customerServiceAr : customerServiceEn;
      case technicion:
        return isArabic ? technicionAr : technicionEn;
      case accountant:
        return isArabic ? accountantAr : accountantEn;
      case supervisor:
        return isArabic ? supervisorAr : supervisorEn;
      case admin:
        return isArabic ? adminAr : adminEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}