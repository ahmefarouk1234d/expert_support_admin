import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'order_main_info.dart';
import 'order_prices.dart';
import 'service_list.dart';

class OrderDetails extends StatelessWidget {
  static String route = "/OrderDetails";
  final int index;
  final OrderInfo order;
  OrderDetails({this.order, this.index});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(order.id),
        elevation: 0.0,
      ),
      body: BlocProvider<OrderBloc>(
        builder: (context, _orderBloc) => _orderBloc ?? OrderBloc(),
        onDispose: (context, _orderBloc) => _orderBloc.dispose(),
        child: Container(
          child: OrderDetailsContent(order: order,),
        ),
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
    super.initState();
  }

   @override
   Widget build(BuildContext context) {
    _orderBloc = Provider.of<OrderBloc>(context);

    return StreamBuilder<OrderInfo>(
      stream: _orderBloc.order,
      initialData: _order,
      builder: (context, snapshot) {
        widgetList = [
          OrderMainInfo(snapshot.data),
          ServicesList(snapshot.data), 
          OrderPrices(snapshot.data), ];

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