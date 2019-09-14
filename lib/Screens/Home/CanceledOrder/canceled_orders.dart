import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_details.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:expert_support_admin/Screens/Home/order_list.dart';

class CanceledOrder extends StatefulWidget {
  @override
  _CanceledOrderOrderState createState() => _CanceledOrderOrderState();
}

class _CanceledOrderOrderState extends State<CanceledOrder> {
  List<OrderInfo> orderList;
  AppBloc _appBloc;

  @override
  void initState() {
    orderList = List();
    super.initState();
  }

  _navigateToCanceledOrderDetails(OrderInfo order, int index){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OrderDetails(order: order, index: index,)));
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _appBloc.canceledOrderDocument,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } 
        orderList = OrderInfo.fromMapList(orderDocDataList: snapshot.data.documents);
        return orderList.isEmpty ? NoData() :  OrderList(orders: orderList, onTap: _navigateToCanceledOrderDetails,);
      }
    );
  }
}