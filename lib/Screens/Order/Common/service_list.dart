import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
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
        bool isArabic = AppLocalizations.of(context).isArabic();
        String serviceNameEn = service.nameEn ?? "";
        String serviceNameAr = service.nameAr ?? "";
        String neededParts = service.neededParts 
          ? AppLocalizations.of(context).translate(LocalizedKey.yesFirstCapital) 
          : AppLocalizations.of(context).translate(LocalizedKey.noFirstCapital);

        return Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: <Widget>[
              Text("x${service.quantity}"),
              Container(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isArabic ? serviceNameAr : serviceNameEn, 
                      style: TextStyle(fontSize: Screen.fontSize(size: 18)),), 
                    Container(height: 8,),
                    Text(
                       AppLocalizations.of(context).translate(LocalizedKey.neededPartsTitle) 
                        + ": $neededParts", 
                       style: TextStyle(color: Colors.grey),)
                  ],
                ),
              ),
              Container(width: 16,),
              Text(service.total.toString() ?? "")
            ],
          ),
        );
      },
    );
  }
}