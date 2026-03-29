import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:flutter/material.dart';

class OfferStatus{
  static const String active = "active";
  static const String deactive = "deactive";
  static const String deleted = "deleted";
  static const String unknown = "unknow";

  static const String activeAr = "نشط";
  static const String activeEn = "Active";
  static const String deactiveAr = "غير نشط";
  static const String deactiveEn = "Deactive";
  static const String deletedAr = "محذوف";
  static const String deletedEn = "Deleted";
  static const String unknownAr = "حالة غير معروفة";
  static const String unknownEn = "Unknow Status";

  String getDisplayStaus({required String status, required BuildContext context}) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    switch (status) {
      case active:
        return isArabic ? activeAr : activeEn;
      case deactive:
        return isArabic ? deletedAr : deactiveEn;
      case deleted:
        return isArabic ? deactiveAr : deletedEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}

class OfferType {
  static const String services = "services";
  static const String packages = "packages";

  static const String servicesAr = "عروض على الخدمات";
  static const String servicesEn = "Offers on Services";
  static const String packagesAr = "عروض الباقات";
  static const String packagesEn = "Packages Offers";
  static const String unknownAr = "حالة غير معروفة";
  static const String unknownEn = "Unknow Status";

  String getDisplayStaus({required String status, required BuildContext context}) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    switch (status) {
      case services:
        return isArabic ? servicesAr : servicesEn;
      case services:
        return isArabic ? packagesAr : packagesEn;
      default:
        return isArabic ? unknownAr : unknownEn;
    }
  }
}