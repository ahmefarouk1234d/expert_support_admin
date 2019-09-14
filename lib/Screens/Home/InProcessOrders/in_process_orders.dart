import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/Order/InProcessOrders/in_process_order_details.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';
import 'package:expert_support_admin/Screens/Home/order_list.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

class InProcessOrder extends StatefulWidget {
  @override
  _InProcessOrderState createState() => _InProcessOrderState();
}

class _InProcessOrderState extends State<InProcessOrder> {
  List<OrderInfo> orderList;
  AppBloc _appBloc;

  @override
  void initState() {
    orderList = List();
    super.initState();
  }

  _navigateToInProcessOrderDetails(OrderInfo order, int index){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => InProcessOrderDetails(order: order, index: index,)));
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _appBloc.inProcessOrderDocument,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } 
        orderList = OrderInfo.fromMapList(orderDocDataList: snapshot.data.documents);
        return orderList.isEmpty ? NoData() :  OrderList(orders: orderList, onTap: _navigateToInProcessOrderDetails,);
      }
    );
  }
}