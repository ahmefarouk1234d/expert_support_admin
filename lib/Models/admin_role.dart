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

  String getDisplayRole({@required String role}) {
    switch (role) {
      case customerService:
        return customerServiceEn;
      case technicion:
        return technicionEn;
      case accountant:
        return accountantEn;
      case supervisor:
        return supervisorEn;
      case admin:
        return adminEn;
      default:
        return unknownEn;
    }
  }
}