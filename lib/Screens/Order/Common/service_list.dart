import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';

class ServicesList extends StatelessWidget {
  final OrderInfo order;
  ServicesList(this.order);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: order.orderService.length,
      itemBuilder: (context, index) {
        OrderService service = order.orderService[index];
        return ListTile(
          leading: Text("x${service.quantity}"),
          title: Text(service.nameEn ?? ""),
          subtitle: Text("has parts: ${service.hasParts}"),
          trailing: Text(service.total.toString() ?? ""),
        );
      },
    );
  }
}