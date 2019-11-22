import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/Home/Offers/offers.dart';
import 'package:expert_support_admin/Screens/Home/Offers/order_offers.dart';
import 'package:expert_support_admin/Screens/Home/Order/inbox.dart';
import 'package:expert_support_admin/Screens/Home/Password/change_password.dart';
import 'package:expert_support_admin/Screens/Home/Users/users.dart';
import 'package:expert_support_admin/Screens/Home/no_role_inbox.dart';
import 'package:flutter/material.dart';

class NavScreen {
  List<NavWidget> navWidget;
  List<String> menuList;

  NavScreen({this.navWidget, this.menuList});
}

class NavWidget {
  Widget widget;
  String title;
  NavWidget({@required this.title, @required this.widget});
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

  MenuList(this.context) {
    this.pendingTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.pendingOrderMenuTitle);
    this.changeRequestTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.changeRequestOrderMenuTitle);
    this.changeRequestReplyTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.changeRequestReplyOrderMenuTitle);
    this.inProcessTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.inProcessOrderMenuTitle);
    this.doneTitle =
        AppLocalizations.of(context).translate(LocalizedKey.doneMenuTitle);
    this.cancelTitle =
        AppLocalizations.of(context).translate(LocalizedKey.cancelMeunTitle);
    this.changePasswordTitle = AppLocalizations.of(context)
        .translate(LocalizedKey.changePasswordMenuTitle);
    this.offersTitle =
        AppLocalizations.of(context).translate(LocalizedKey.offerMenuTitle);
    this.usersTitle =
        AppLocalizations.of(context).translate(LocalizedKey.usersMenuTitle);
    this.ordersTitle =
        AppLocalizations.of(context).translate(LocalizedKey.ordersMenuTitle);
    this.signOutTitle =
        AppLocalizations.of(context).translate(LocalizedKey.signOutMenuTitle);
  }

  NavScreen getCustomerServiceList() {
    NavScreen _navScreenListCustomerService = NavScreen(navWidget: [
      NavWidget(
          title: pendingTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.pending,
          )),
      NavWidget(
          title: changeRequestTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.requestChange,
          )),
      NavWidget(title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      pendingTitle,
      changeRequestTitle,
      changePasswordTitle,
      signOutTitle
    ]);
    return _navScreenListCustomerService;
  }

  NavScreen getTechList() {
    NavScreen _navScreenListTech = NavScreen(navWidget: [
      NavWidget(
          title: ordersTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.inProcess,
          )),
      NavWidget(
          title: changeRequestReplyTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.requestChangeReply,
          )),
      NavWidget(
          title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      ordersTitle,
      changeRequestReplyTitle,
      changePasswordTitle,
      signOutTitle
    ]);
    return _navScreenListTech;
  }

  NavScreen getAccountantList() {
    NavScreen _navScreenListAccountant = NavScreen(navWidget: [
      NavWidget(
          title: ordersTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.done,
          )),
      NavWidget(
          title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      ordersTitle,
      changePasswordTitle,
      signOutTitle
    ]);
    return _navScreenListAccountant;
  }

  NavScreen getSuperviorList() {
    NavScreen _navScreenListSupervior = NavScreen(navWidget: [
      NavWidget(
          title: pendingTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.pending,
          )),
      NavWidget(
          title: changeRequestTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.requestChange,
          )),
      NavWidget(
          title: inProcessTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.inProcess,
          )),
      NavWidget(
          title: changeRequestReplyTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.requestChangeReply,
          )),
      NavWidget(
          title: doneTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.done,
          )),
      NavWidget(
          title: cancelTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.canceled,
          )),
      NavWidget(title: offersTitle, widget: OrderOffer()),
      NavWidget(
          title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      pendingTitle,
      changeRequestTitle,
      inProcessTitle,
      changeRequestReplyTitle,
      doneTitle,
      cancelTitle,
      offersTitle,
      changePasswordTitle,
      signOutTitle
    ]);
    return _navScreenListSupervior;
  }

  NavScreen getAdminList() {
    NavScreen _navScreenListAdmin = NavScreen(navWidget: [
      NavWidget(
          title: ordersTitle,
          widget: OrderInbox(
            workflowStatus: WorkflowStatus.unknown,
          )),
      NavWidget(title: offersTitle, widget: OrderOffer()),
      NavWidget(title: usersTitle, widget: Users()),
      NavWidget(
          title: changePasswordTitle, widget: ChangePassword()),
    ], menuList: [
      ordersTitle,
      offersTitle,
      usersTitle,
      changePasswordTitle,
      signOutTitle
    ]);
    return _navScreenListAdmin;
  }

  NavScreen _navScreenListNoRole = NavScreen(navWidget: [
    NavWidget(title: TextContent.homeTitle, widget: NoRoleInbox()),
  ], menuList: [
    TextContent.homeMenu,
    TextContent.signOutMenu
  ]);

  NavScreen getMenuList(String role) {
    if (role != null) {
      NavScreen menuList;
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
      return menuList;
    }
    return _navScreenListNoRole;
  }
}
