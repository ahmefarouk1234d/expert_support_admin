import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final List<OrderInfo> orders;
  final Function(OrderInfo order, int index)? onTap;
  const OrderList({super.key, this.orders = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
          child: ListView.separated(
            padding: EdgeInsets.all(8),
            itemCount: orders.length,
            separatorBuilder: (context, index) => Divider(color: Colors.black12,),
            itemBuilder: (context, index) {
              final OrderInfo order = orders[index];
              
              return OrderListTile(order: order, onTap: () => onTap!(order, index),);
            }
          )
        );
  }
}

class OrderListTile extends StatelessWidget {
  const OrderListTile({super.key, required this.order, this.onTap});

  final OrderInfo order;
  final Function()? onTap;

  String _getVisitDateDisplay(BuildContext context) {
    String title = AppLocalizations.of(context).translate(LocalizedKey.orderVisitDateTitle);
    String dateString = DateConvert().toStringFromDate(
      date: order.visitDate!, 
      locale: AppLocalizations.of(context).locale.languageCode, 
      isFull: true
    );

    return "$title : $dateString";
  }

  String _getLastUpdateDateDisplay(BuildContext context) {
    String title = AppLocalizations.of(context).translate(LocalizedKey.lastUpdateDateTitle);
    String dateString = DateConvert().toStringFromDate(
      date: (order.dateUpdate ?? order.dateCreated)!, 
      locale: AppLocalizations.of(context).locale.languageCode, 
      isFull: true
    );

    return "$title : $dateString";
  }

  @override
  Widget build(BuildContext context) {
    final String workflowStatus = 
      order.workflowStatus != null 
      ? WorkflowStatus().getDisplayStatus(status: order.workflowStatus!, context: context)
      : "";

    return ListTile(
      onTap: onTap,
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(order.id ?? "")
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_getVisitDateDisplay(context)),
          Container(height: 4),
          Text(_getLastUpdateDateDisplay(context))
        ],
      ),
      trailing: Text(workflowStatus)
    );
  }
}
