import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:flutter/material.dart';

class OrderPrices extends StatelessWidget {
  final OrderInfo order;
  OrderPrices(this.order);

  @override
  Widget build(BuildContext context) {
    num totalPrice = order.totalPriceAfterDiscount != 0.0
        ? order.totalPriceAfterDiscount
        : order.totalPriceBeforeDiscount;
    AppLocalizations localizations = AppLocalizations.of(context);

    final double totalPriceWithPartsPrice = order.partsFees + order.adminFees + order.totalPriceWithVAT;
    final double totalRemaining = 
      double.parse(order.totalMoneyReceived.toStringAsFixed(2)) - 
      double.parse(totalPriceWithPartsPrice.toStringAsFixed(2));
    final double totalRemainingAbs = totalRemaining.abs();
    final bool isDone = order.workflowStatus == WorkflowStatus.done;
    final double finalTotalPrice = isDone 
      ? double.parse(totalPriceWithPartsPrice.toStringAsFixed(2))
      : double.parse(order.totalPriceWithVAT.toStringAsFixed(2));
    final String sign = totalRemaining == 0 ? "" : totalRemaining < 0 ? "-" : "+";
    

    return Container(
      child: Column(
        children: <Widget>[
          PriceRow(
            title: localizations.translate(LocalizedKey.discountTitle), 
            price: order.discountPercent,),
          PriceRow(
            title: localizations.translate(LocalizedKey.totalDiscountTitle), 
            price: order.totalDiscountAmount,),
          order.adminDiscount != null 
            ? PriceRow(
              title: localizations.translate(LocalizedKey.adminDiscountTitle), 
              price: order.adminDiscount,)
            : Container(),
          PriceRow(
            title: localizations.translate(LocalizedKey.estimatedTotalTitle), 
            price: totalPrice,),
          PriceRow(
            title: localizations.translate(LocalizedKey.vatTitle) + ' (%${order.vatPercentage ?? 5})', 
            price: order.vatTotal,),
          isDone 
            ? Column(
                children: <Widget>[
                  PriceRow(
                    title: AppLocalizations.of(context).translate(LocalizedKey.adminFeesTitle), 
                    price: order.partsFees,),
                  PriceRow(
                    title: AppLocalizations.of(context).translate(LocalizedKey.partsTotalPriceTitle), 
                    price: order.adminFees,),
                ],
              )
            : Container(),
          PriceRow(
            title: localizations.translate(LocalizedKey.totalPriceTitle), 
            price: finalTotalPrice,),
          isDone 
            ? Column(
                children: <Widget>[
                  PriceRow(
                    title: AppLocalizations.of(context).translate(LocalizedKey.totalPaidTitle), 
                    price: order.totalMoneyReceived,),
                  PriceRow(
                    title: AppLocalizations.of(context).translate(LocalizedKey.totalRemainingTitle), 
                    price: totalRemainingAbs,
                    intSign: sign,)
                ],
              )
            : Container()
        ],
      ),
    );
  }
}

class ExtraPriceInfo extends StatelessWidget {
  ExtraPriceInfo({Key key, @required this.order}): super(key: key);
  
  final OrderInfo order;

  @override
  Widget build(BuildContext context) {
    final double totalRemaining = 
      double.parse(order.totalMoneyReceived.toStringAsFixed(2)) - 
      double.parse(order.totalPriceWithVAT.toStringAsFixed(2));
    return Container(
      child: Column(
        children: <Widget>[
          PriceRow(
            title: AppLocalizations.of(context).translate(LocalizedKey.adminFeesTitle), 
            price: order.partsFees,),
          PriceRow(
            title: AppLocalizations.of(context).translate(LocalizedKey.partsTotalPriceTitle), 
            price: order.adminFees,),
          PriceRow(
            title: AppLocalizations.of(context).translate(LocalizedKey.totalPaidTitle), 
            price: order.totalMoneyReceived,),
          totalRemaining < 0 
            ? PriceRow(
                title: AppLocalizations.of(context).translate(LocalizedKey.totalRemainingTitle), 
                price: totalRemaining,)
            : Container(),
        ],
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String title;
  final num price;
  final String intSign;
  PriceRow({@required this.title, @required this.price, this.intSign = ""});

  @override
  Widget build(BuildContext context) {
    String priceString = price == null ? '0.0' : price.toStringAsFixed(2);

    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
            children: <Widget>[
              Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w700),),),
              Container(width: 8,),
              Text(intSign + priceString), //toStringAsFixed(2) to show two decimal point.
            ],
          ),
    );
  }
}