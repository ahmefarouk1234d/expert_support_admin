import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:expert_support_admin/Screens/Home/Discount/discount.dart';
import 'package:expert_support_admin/Screens/Home/Offers/order_offers.dart';
import 'package:expert_support_admin/Screens/Home/Order/inbox.dart';
import 'package:expert_support_admin/Screens/Home/Password/change_password.dart';
import 'package:expert_support_admin/Screens/Home/Users/users.dart';
import 'package:expert_support_admin/Screens/Home/Notifications/send_notification.dart';
import 'package:expert_support_admin/Screens/Home/Services/service_management.dart';
import 'package:expert_support_admin/Screens/Home/generalDetails/general_details.dart';
import 'package:expert_support_admin/Screens/Home/no_role_inbox.dart';
import 'package:flutter/material.dart';

class NavScreen {
  List<NavWidget> navWidget;
  List<String> menuList;

  NavScreen({required this.navWidget, required this.menuList});
}

class NavWidget {
  Widget widget;
  String title;
  NavWidget({required this.title, required this.widget});
}

class MenuList {
  final BuildContext context;
  String pendingTitle = "";
  String changeRequestTitle = "";
  String changeRequestReplyTitle = "";
  String inProcessTitle = "";
  String doneTitle = "";
  String cancelTitle = "";
  String changePasswordTitle = "";
  String offersTitle = "";
  String usersTitle = "";
  String ordersTitle = "";
  String signOutTitle = "";
  String discount = "";
  String generalDetailsTitle = "";
  String ordersHistory = "";
  String servicesTitle = "";
  String notificationsTitle = "";

  MenuList(this.context) {
    pendingTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.pendingOrderMenuTitle);
    changeRequestTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.changeRequestOrderMenuTitle);
    changeRequestReplyTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.changeRequestReplyOrderMenuTitle);
    inProcessTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.inProcessOrderMenuTitle);
    doneTitle =
        AppLocalizations.of(context).translate(LocalizedKey.doneMenuTitle);
    cancelTitle =
        AppLocalizations.of(context).translate(LocalizedKey.cancelMeunTitle);
    changePasswordTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.changePasswordMenuTitle);
    offersTitle =
        AppLocalizations.of(context).translate(LocalizedKey.offerMenuTitle);
    usersTitle =
        AppLocalizations.of(context).translate(LocalizedKey.usersMenuTitle);
    ordersTitle =
        AppLocalizations.of(context).translate(LocalizedKey.ordersMenuTitle);
    signOutTitle =
        AppLocalizations.of(context).translate(LocalizedKey.signOutMenuTitle);
    discount =
        AppLocalizations.of(context).translate(LocalizedKey.discountMenuTitle);
    generalDetailsTitle =
        AppLocalizations.of(context).translate(LocalizedKey.generalDetailsMenuTitle);
    ordersHistory =
        AppLocalizations.of(context).translate(LocalizedKey.orderHistoryMenuTitle);
    servicesTitle =
        AppLocalizations.of(context).translate(LocalizedKey.servicesMenuTitle);
    notificationsTitle =
        AppLocalizations.of(context).translate(LocalizedKey.notificationsMenuTitle);
  }

  NavScreen getCustomerServiceList() {
    NavScreen navScreenListCustomerService = NavScreen(navWidget: [
      NavWidget(
          title: pendingTitle,
          widget: OrderInbox(
            orderToDisplay: OrderToDisplay.pending,
          )),
      NavWidget(title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      pendingTitle,
      changePasswordTitle,
      signOutTitle
    ]);
    return navScreenListCustomerService;
  }

  NavScreen getTechList() {
    NavScreen navScreenListTech = NavScreen(navWidget: [
      NavWidget(
          title: ordersTitle,
          widget: OrderInbox(
            orderToDisplay: OrderToDisplay.inProcess,
          )),
      NavWidget(
          title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      inProcessTitle,
      changePasswordTitle,
      signOutTitle
    ]);
    return navScreenListTech;
  }

  NavScreen getAccountantList() {
    NavScreen navScreenListAccountant = NavScreen(navWidget: [
      NavWidget(
          title: ordersTitle,
          widget: OrderInbox(
            orderToDisplay: OrderToDisplay.done,
          )),
      NavWidget(title: offersTitle, widget: OrderOffer()),
      NavWidget(title: discount, widget: DiscountPage()),
      NavWidget(
          title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      ordersTitle,
      offersTitle,
      discount,
      changePasswordTitle,
      signOutTitle
    ]);
    return navScreenListAccountant;
  }

  NavScreen getSuperviorList() {
    NavScreen navScreenListSupervior = NavScreen(navWidget: [
      NavWidget(
          title: pendingTitle,
          widget: OrderInbox(
            orderToDisplay: OrderToDisplay.pending,
          )),
      NavWidget(
          title: inProcessTitle,
          widget: OrderInbox(
            orderToDisplay: OrderToDisplay.inProcess,
          )),
      NavWidget(
          title: doneTitle,
          widget: OrderInbox(
            orderToDisplay: OrderToDisplay.done,
          )),
      NavWidget(
          title: cancelTitle,
          widget: OrderInbox(
            orderToDisplay: OrderToDisplay.canceled,
          )),
      NavWidget(title: offersTitle, widget: OrderOffer()),
      NavWidget(title: discount, widget: DiscountPage()),
      NavWidget(
          title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      pendingTitle,
      inProcessTitle,
      doneTitle,
      cancelTitle,
      offersTitle,
      discount,
      changePasswordTitle,
      signOutTitle
    ]);
    return navScreenListSupervior;
  }

  NavScreen getAdminList() {
    NavScreen navScreenListAdmin = NavScreen(navWidget: [
      NavWidget(
          title: ordersTitle,
          widget: OrderInbox(
            orderToDisplay: OrderToDisplay.all,
          )),
      NavWidget(title: offersTitle, widget: OrderOffer()),
      NavWidget(title: discount, widget: DiscountPage()),
      NavWidget(title: usersTitle, widget: Users()),
      NavWidget(title: generalDetailsTitle, widget: GeneralDetails()),
      NavWidget(title: servicesTitle, widget: ServiceManagement()),
      NavWidget(title: notificationsTitle, widget: SendNotification()),
      //NavWidget(title: ordersHistory, widget: Users()),
      NavWidget(
          title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      ordersTitle,
      offersTitle,
      discount,
      usersTitle,
      generalDetailsTitle,
      servicesTitle,
      notificationsTitle,
      //ordersHistory,
      changePasswordTitle,
      signOutTitle
    ]);
    return navScreenListAdmin;
  }

  late final NavScreen _navScreenListNoRole = NavScreen(navWidget: [
    NavWidget(title: TextContent.homeTitle, widget: NoRoleInbox()),
  ], menuList: [
    TextContent.homeMenu,
    TextContent.signOutMenu
  ]);

  NavScreen getMenuList(String? role) {
    if (role != null) {
      NavScreen? menuList;
      switch (role) {
        case AdminRole.customerService:
          menuList = getCustomerServiceList();
          break;
        case AdminRole.technicion:
          menuList = getTechList();
          break;
        case AdminRole.accountant:
          menuList = getAccountantList();
          break;
        case AdminRole.supervisor:
          menuList = getSuperviorList();
          break;
        case AdminRole.admin:
          menuList = getAdminList();
          break;
      }
      return menuList ?? _navScreenListNoRole;
    }
    return _navScreenListNoRole;
  }
}
