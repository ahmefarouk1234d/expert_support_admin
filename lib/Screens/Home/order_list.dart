import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final List<OrderInfo> orders;
  final Function(OrderInfo order, int index) onTap;
  OrderList({this.orders, this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return Container(
          child: ListView.separated(
            padding: EdgeInsets.all(8),
            itemCount: orders.length,
            separatorBuilder: (context, index) => Divider(color: Colors.black12,),
            itemBuilder: (context, index) {
              final OrderInfo order = orders[index];
              final String orderStatus = 
                order.status != null 
                ? OrderStatus().getDisplayStatus(status: order.status, context: context)
                : "";
              bool hasDateCreated = order.dateCreated != null;
              return ListTile(
                onTap: () => onTap(order, index),
                title: Text(order.id ?? ""),
                subtitle: Text(
                  hasDateCreated ?
                  DateConvert().toStringFromDate(
                    date: order.dateCreated, 
                    locale: AppLocalizations.of(context).locale.languageCode) : ""),
                trailing: Text(orderStatus)
              );
            }
          )
        );
  }
}