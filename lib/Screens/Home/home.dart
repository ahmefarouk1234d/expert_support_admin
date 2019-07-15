import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/Main/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/Main/app_bloc_provider.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/Home/main_drawer.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';
import 'order_list.dart';


class Home extends StatefulWidget {
  static const route = "/Home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<OrderInfo> orderList;
  AppBloc _appBloc;

  @override
  void initState() {
    orderList = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = AppProvider.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _appBloc.orderDocument,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } 
        orderList = OrderInfo.fromMapList(orderDocDataList: snapshot.data.documents);
        return orderList.isEmpty ? NoData() :  OrderList(orders: orderList);
      }
    );
    // Scaffold(
    //     appBar: AppBar(
    //       title: Text(TextContent.homeTitle),
    //       elevation: 0.0,
    //     ),
    //     drawer: MainDrawer(),
    //     body: StreamBuilder<QuerySnapshot>(
    //       stream: _appBloc.orderDocument,
    //       builder: (context, snapshot) {
    //         if (!snapshot.hasData) {
    //           return Loading();
    //         } 
    //         orderList = OrderInfo.fromMapList(orderDocDataList: snapshot.data.documents);
    //         return orderList.isEmpty ? NoData() :  OrderList(orders: orderList);
    //       }
    //     )
    // );
  }

  @override
  void dispose() {
    _appBloc.dispose();
    super.dispose();
  }
}