import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';


class NoRoleInbox extends StatefulWidget {
  static const route = "/Home";

  @override
  _NoRoleInboxState createState() => _NoRoleInboxState();
}

class _NoRoleInboxState extends State<NoRoleInbox> {
  List<OrderInfo> orderList;
  AppBloc _appBloc;

  @override
  void initState() {
    orderList = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return Container(
      child: Center(child: Text("Could not get your role. Please contact support for more info with you email."),),
    );
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text(TextContent.homeTitle),
    //     elevation: 0.0,
    //   ),
    //   body: StreamBuilder<QuerySnapshot>(
    //     stream: _appBloc.orderDocument,
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return Loading();
    //       } 
    //       orderList = OrderInfo.fromMapList(orderDocDataList: snapshot.data.documents);
    //       return orderList.isEmpty ? NoData() :  OrderList(orders: orderList);
    //     }
    //   ),
    // );
  }
}

class OrderList extends StatelessWidget {
  final List<OrderInfo> orders;
  OrderList({this.orders});

  @override
  Widget build(BuildContext context) {
    return Container(
          child: ListView.separated(
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) => OrderRow(index, orders[index]),
            itemCount: orders.length,
            separatorBuilder: (context, index) => Divider(color: Colors.black12,),
          )
        );
  }
}

class OrderRow extends StatelessWidget {
  final int index;
  final OrderInfo order;
  OrderRow(this.index, this.order);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(order.id ?? ""),
      subtitle: Text(order.dateCreated ?? ""),
      trailing: Text(order.status ?? ""),
    );
  }
}