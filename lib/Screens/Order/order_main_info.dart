import 'package:expert_support_admin/BlocResources/Order/order_bloc.dart';
import 'package:expert_support_admin/BlocResources/Order/order_provider.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

class OrderMainInfo extends StatelessWidget {
  final OrderInfo order;
  OrderMainInfo(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(
            children: <Widget>[
              OrderInfoRow(title: "customer name:", value: "${order.username}",),
              OrderInfoRow(title: "customer phone:", value: "${order.userPhone}",),
              OrderInfoRow(title: "status:", value: "${order.status}",),
              OrderInfoRow(title: "Date:", value: "${order.visitDate}",),
              OrderInfoRow(title: "Time:", value: "${order.visitTime}",),
              OrderInfoRow(title: "Locations:", value: "${order.coordinate.latitude}, ${order.coordinate.logntitude}",),
              OrderInfoRow(title: "Other details:", value: "${order.comment}",),
            ],
          ),
        );
  }
}

class OrderInfoRow extends StatelessWidget {
  final String title;
  final String value;
  OrderInfoRow({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
            children: <Widget>[
              Text(title),
              Container(width: 8,),
              Expanded(child: Text(value),)
            ],
          ),
    );
  }
}