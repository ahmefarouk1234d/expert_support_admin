import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/Order/order_details.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final List<OrderInfo> orders;
  OrderList({this.orders});
  //AppBloc _appBloc;

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

  _navigateToOrderDetails(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetails(order: order, index: index,)));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _navigateToOrderDetails(context),
      title: Text(order.id ?? ""),
      subtitle: Text(order.dateCreated ?? ""),
      trailing: Text(order.status ?? ""),
    );
  }
}