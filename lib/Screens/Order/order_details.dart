import 'package:expert_support_admin/BlocResources/Order/order_bloc.dart';
import 'package:expert_support_admin/BlocResources/Order/order_provider.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';
import 'order_main_info.dart';
import 'order_prices.dart';
import 'order_buttons_actions.dart';
import 'service_list.dart';

class OrderDetails extends StatelessWidget {
  final int index;
  final OrderInfo order;
  OrderDetails({this.order, this.index});

  final OrderBloc _editOrderBloc = OrderBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextContent.orderDetailsTitle),
        elevation: 0.0,
      ),
      body: OrderBlocProvider(
        builder: (context, editOrderBloc) => _editOrderBloc,
        onDispose: (context, editOrderBloc) => _editOrderBloc.dispose(),
        child: Container(
          child: OrderDetailsContent(order: order,)),
        ),
    );
  }
}

class OrderDetailsContent extends StatefulWidget {
  final OrderInfo order;
  OrderDetailsContent({this.order});

  @override
  _OrderDetailsContentState createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<OrderDetailsContent> {
  List<Widget> widgetList;
  OrderInfo _order;
  OrderBloc _orderBloc;

  @override
  void initState() {
    _order = widget.order;
    widgetList = [
      OrderMainInfo(_order),
      ServicesList(_order), 
      OrderPrices(_order), 
      OrderActionButtons(_order,)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc = OrderProvider.of(context);

    return StreamBuilder<OrderInfo>(
      stream: _orderBloc.order,
      initialData: _order,
      builder: (context, snapshot) {
        widgetList = [
          OrderMainInfo(snapshot.data),
          ServicesList(snapshot.data), 
          OrderPrices(snapshot.data), 
          OrderActionButtons(snapshot.data,)];

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: widgetList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[widgetList[index]],
            );
          },
        );
      }
    );
  }
}