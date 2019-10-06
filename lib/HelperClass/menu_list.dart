import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/Home/Offers/add_offer.dart';
import 'package:expert_support_admin/Screens/Home/Offers/offers.dart';
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
  NavScreen _navScreenListCustomerService = NavScreen(navWidget: [
    NavWidget(
        title: TextContent.pendingTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.pending,
        )),
    NavWidget(
        title: TextContent.requestChangeTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.requestChange,
        )),
    NavWidget(
        title: TextContent.changePasswordTitle,
        widget: ChangePassword()
        ),
  ], menuList: [
    TextContent.pendingTitle,
    TextContent.requestChangeTitle,
    TextContent.changePasswordTitle,
    TextContent.signOutMenu
  ]);

  NavScreen _navScreenListTech = NavScreen(navWidget: [
    NavWidget(
        title: TextContent.homeTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.inProcess,
        )),
    NavWidget(
        title: TextContent.changePasswordTitle,
        widget: ChangePassword()
        ),
  ], menuList: [
    TextContent.homeMenu,
    TextContent.changePasswordTitle,
    TextContent.signOutMenu
  ]);

  NavScreen _navScreenListAccountant = NavScreen(navWidget: [
    NavWidget(
        title: TextContent.homeTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.done,
        )),
    NavWidget(
        title: TextContent.changePasswordTitle,
        widget: ChangePassword()
        ),
  ], menuList: [
    TextContent.homeMenu,
    TextContent.changePasswordTitle,
    TextContent.signOutMenu
  ]);

  NavScreen _navScreenListSupervior = NavScreen(navWidget: [
    NavWidget(
        title: TextContent.pendingTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.pending,
        )),
    NavWidget(
        title: TextContent.requestChangeTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.requestChange,
        )),
    NavWidget(
        title: TextContent.inProcessTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.inProcess,
        )),
    NavWidget(
        title: TextContent.doneTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.done,
        )),
    NavWidget(
        title: TextContent.canceledTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.canceled,
        )),
    NavWidget(title: TextContent.offerTitle, widget: Offers()),
    NavWidget(
        title: TextContent.changePasswordTitle,
        widget: ChangePassword()
        ),
  ], menuList: [
    TextContent.pendingTitle,
    TextContent.requestChangeTitle,
    TextContent.inProcessTitle,
    TextContent.doneTitle,
    TextContent.canceledTitle,
    TextContent.offerMenu,
    TextContent.changePasswordTitle,
    TextContent.signOutMenu
  ]);

  NavScreen _navScreenListAdmin = NavScreen(navWidget: [
    NavWidget(
        title: TextContent.homeTitle,
        widget: OrderInbox(
          orderStatus: OrderStatus.unknown,
        )),
    NavWidget(title: TextContent.offerTitle, widget: Offers()),
    NavWidget(title: TextContent.usersTitle, widget: Users()),
    NavWidget(
        title: TextContent.changePasswordTitle,
        widget: ChangePassword()
        ),
  ], menuList: [
    TextContent.homeMenu,
    TextContent.offerMenu,
    TextContent.usersMune,
    TextContent.changePasswordTitle,
    TextContent.signOutMenu
  ]);

  NavScreen _navScreenListNoRole = NavScreen(navWidget: [
    NavWidget(
        title: TextContent.homeTitle,
        widget: NoRoleInbox()),
  ], menuList: [
    TextContent.homeMenu,
    TextContent.signOutMenu
  ]);

  NavScreen getMenuList(String role){
    if (role != null) {
      NavScreen menuList;
      switch(role){
        case AdminRole.customerService: 
          menuList = _navScreenListCustomerService;
          break;
        case AdminRole.technicion: 
          menuList = _navScreenListTech;
          break;
        case AdminRole.accountant: 
          menuList = _navScreenListAccountant;
          break;
        case AdminRole.supervisor: 
          menuList = _navScreenListSupervior;
          break;
        case AdminRole.admin: 
          menuList = _navScreenListAdmin;
          break;
      }
      return menuList;
    }
    return _navScreenListNoRole;
  }
}
