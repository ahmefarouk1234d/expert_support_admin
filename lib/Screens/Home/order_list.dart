import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
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
              final String workflowStatus = 
                order.workflowStatus != null 
                ? WorkflowStatus().getDisplayStatus(status: order.workflowStatus, context: context)
                : "";
              bool hasDateUpdate = order.dateUpdate != null;
              return ListTile(
                onTap: () => onTap(order, index),
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(order.id ?? "")
                ),
                subtitle: Column(
                  children: <Widget>[
                    OrderDateText(
                      localizedKeyTitle: LocalizedKey.orderVisitDateTitle,
                      date: order.visitDate,
                    ),
                    Container(height: 4),
                    OrderDateText(
                      localizedKeyTitle: LocalizedKey.lastUpdateDateTitle,
                      date: hasDateUpdate ? order.dateUpdate : order.dateCreated,
                    )
                  ],
                ),
                trailing: Text(workflowStatus)
              );
            }
          )
        );
  }
}

class OrderDateText extends StatelessWidget {
  OrderDateText({Key key, this.localizedKeyTitle, this.date});

  final DateTime date;
  final String localizedKeyTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate(localizedKeyTitle)
            + ":"
          ),
          Container(width: 8,),
          Text(
            DateConvert().toStringFromDate(
              date: date, 
              locale: AppLocalizations.of(context).locale.languageCode
            )
          ),
        ],
      ),
    );
  }
}