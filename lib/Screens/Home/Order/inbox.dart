import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/Home/Order/details.dart';
import 'package:expert_support_admin/Screens/Home/order_list.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

class OrderInbox extends StatelessWidget {
  static const route = "/OrderInbox";
  final OrderToDisplay orderToDisplay;
  OrderInbox({this.orderToDisplay});

  @override
  Widget build(BuildContext context) {
    return OrdersList(
      orderToDisplay: orderToDisplay,
    );
  }
}

class OrdersList extends StatefulWidget {
  final OrderToDisplay orderToDisplay;
  OrdersList({this.orderToDisplay});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<OrderInfo> orderList;
  AppBloc _appBloc;

  @override
  void initState() {
    orderList = List();
    super.initState();
  }

  _navigateToOrderDetails(OrderInfo order, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OrderDetails(
              order: order,
              index: index,
              orderToDisplay: widget.orderToDisplay,
            )));
  }

  Stream<QuerySnapshot> getOrderDocStream() {
    Stream<QuerySnapshot> orderStream;
    switch (widget.orderToDisplay) {
      //Getting all pending and change request orders
      case OrderToDisplay.pending:
        orderStream = _appBloc.pendingOrderDocument;
        break;
      case OrderToDisplay.inProcess:
        orderStream = _appBloc.inProcessOrderDocument;
        break;
      case OrderToDisplay.done:
        orderStream = _appBloc.doneOrderDocument;
        break;
      case OrderToDisplay.canceled:
        orderStream = _appBloc.canceledOrderDocument;
        break;
      case OrderToDisplay.all:
        orderStream = _appBloc.orderDocument;
    }
    return orderStream;
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: getOrderDocStream(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return NoData();
            default:
              if (!snapshot.hasData) {
                Loading();
              }
              orderList = OrderInfo.fromMapList(
                  orderDocDataList: snapshot.data.documents);
              return orderList.isEmpty
                  ? NoData()
                  : OrderList(
                      orders: orderList.reversed.toList(),
                      onTap: _navigateToOrderDetails,
                    );
          }
        });
  }
}
