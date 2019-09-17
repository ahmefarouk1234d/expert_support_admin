import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/Home/Order/details.dart';
import 'package:expert_support_admin/Screens/Home/order_list.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

class OrderInbox extends StatelessWidget {
  static const route = "/OrderInbox";
  final String orderStatus;
  OrderInbox({this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return OrdersList(orderStatus: orderStatus,);
  }
}

class OrdersList extends StatefulWidget {
  final String orderStatus;
  OrdersList({this.orderStatus});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<OrderInfo> orderList;
  AppBloc _appBloc;
  String orderStatus;

  @override
  void initState() {
    orderList = List();
    super.initState();
  }

  _navigateToOrderDetails(OrderInfo order, int index){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OrderDetails(order: order, index: index, orderStatus: widget.orderStatus,)));
  }

  Stream<QuerySnapshot> getOrderDoc(){
    Stream<QuerySnapshot> orderStream;
    switch(widget.orderStatus){
      case OrderStatus.pending: 
        orderStream = _appBloc.pendingOrderDocument;
        break;
      case OrderStatus.requestChange: 
        orderStream = _appBloc.requestChangeOrderDocument;
        break;
      case OrderStatus.inProcess: 
        orderStream = _appBloc.inProcessOrderDocument;
        break;
      case OrderStatus.done: 
        orderStream = _appBloc.doneOrderDocument;
        break;
      case OrderStatus.canceled: 
        orderStream = _appBloc.canceledOrderDocument;
        break;
      case OrderStatus.unknown:
        orderStream = _appBloc.orderDocument;
    }
    return orderStream;
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: getOrderDoc(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } 
        orderList = OrderInfo.fromMapList(orderDocDataList: snapshot.data.documents);
        return orderList.isEmpty 
          ? NoData() 
          : OrderList(
              orders: orderList.reversed.toList(), 
              onTap: _navigateToOrderDetails,
            );
      }
    );
  }
}