import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/Home/Order/details/details.dart';
import 'package:expert_support_admin/Screens/Home/order_list.dart';
import 'package:expert_support_admin/Screens/Order/Common/fliter_order.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

class OrderInbox extends StatelessWidget {
  static const route = "/OrderInbox";
  final OrderToDisplay? orderToDisplay;
  const OrderInbox({super.key, this.orderToDisplay});

  @override
  Widget build(BuildContext context) {
    return OrdersList(
      orderToDisplay: orderToDisplay,
    );
  }
}

class OrdersList extends StatefulWidget {
  final OrderToDisplay? orderToDisplay;
  const OrdersList({super.key, this.orderToDisplay});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<OrderInfo> orderList = [];
  late AppBloc _appBloc;

  @override
  void initState() {
    super.initState();
  }

  void _navigateToOrderDetails(OrderInfo order, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OrderDetails(
              order: order,
              index: index,
              orderToDisplay: widget.orderToDisplay,
            )));
  }

  Stream<QuerySnapshot>? getOrderDocStream() {
    Stream<QuerySnapshot>? orderStream;
    switch (widget.orderToDisplay!) {
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

  void _handleFromDate(DateTime date) async {
    _appBloc.fromDateChange.add(date);
  }

  void _handleToDate(DateTime date) async {
    _appBloc.toDateChange.add(date);
  }

  void _handleSearch() {
    setState(() {});
  }

  void _handleClearSeach() {
    setState(() {
      _appBloc.fromDateChange.add(null);
      _appBloc.toDateChange.add(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return Column(
      children: <Widget>[
        FliterOrder(
          onFromDateTap: (date) {
            _handleFromDate(date);
          },
          onToDateTap: (date) {
            _handleToDate(date);
          },
          onSearchTap: () {
            _handleSearch();
          },
          onClearTap: () {
            _handleClearSeach();
          },
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: getOrderDocStream(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Loading();
                  default:
                    if (!snapshot.hasData) {
                      return NoData();
                    }
                    orderList = OrderInfo.fromMapList(
                        orderDocDataList: snapshot.data!.docs);
                    return orderList.isEmpty
                        ? NoData()
                        : OrderList(
                            orders: orderList, //.reversed.toList(),
                            onTap: _navigateToOrderDetails,
                          );
                }
              }),
        ),
      ],
    );
  }
}
