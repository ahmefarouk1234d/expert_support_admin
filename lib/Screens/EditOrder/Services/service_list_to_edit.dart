import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';

import 'service_row_to_edit.dart';

class ServiceListToEdit extends StatelessWidget {
  final List<OrderService> services;
  ServiceListToEdit({this.services});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ServiceRowToEdit(services: services, index: index,);
        });
  }
}