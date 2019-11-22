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
  final String workflowStatus;
  OrderInbox({this.workflowStatus});

  @override
  Widget build(BuildContext context) {
    return OrdersList(workflowStatus: workflowStatus,);
  }
}

class OrdersList extends StatefulWidget {
  final String workflowStatus;
  OrdersList({this.workflowStatus});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<OrderInfo> orderList;
  AppBloc _appBloc;
  String workflowStatus;

  @override
  void initState() {
    orderList = List();
    super.initState();
  }

  _navigateToOrderDetails(OrderInfo order, int index){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OrderDetails(order: order, index: index, workflowStatus: widget.workflowStatus,)));
  }

  Stream<QuerySnapshot> getOrderDoc(){
    Stream<QuerySnapshot> orderStream;
    switch(widget.workflowStatus){
      case WorkflowStatus.pending: 
        orderStream = _appBloc.pendingOrderDocument;
        break;
      case WorkflowStatus.requestChange: 
        orderStream = _appBloc.requestChangeOrderDocument;
        break;
      case WorkflowStatus.inProcess: 
        orderStream = _appBloc.inProcessOrderDocument;
        break;
      case WorkflowStatus.requestChangeReply: 
        orderStream = _appBloc.requestChangeReplyOrderDocument;
        break;
      case WorkflowStatus.done: 
        orderStream = _appBloc.doneOrderDocument;
        break;
      case WorkflowStatus.canceled: 
        orderStream = _appBloc.canceledOrderDocument;
        break;
      case WorkflowStatus.unknown:
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