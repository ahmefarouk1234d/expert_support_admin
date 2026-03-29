import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:flutter/material.dart';

class OrderPrices extends StatelessWidget {
  final OrderInfo order;
  const OrderPrices(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    num totalPrice = order.totalPriceAfterDiscount != 0.0
        ? (order.totalPriceAfterDiscount ?? 0)
        : (order.totalPriceBeforeDiscount ?? 0);
    AppLocalizations localizations = AppLocalizations.of(context);

    final double totalPriceWithPartsPrice =
        ((order.partsFees ?? 0) + (order.adminFees ?? 0) + (order.totalPriceWithVAT ?? 0)).toDouble();
    final double totalRemaining = 
      double.parse((order.totalMoneyReceived ?? 0).toStringAsFixed(2)) - 
      double.parse(totalPriceWithPartsPrice.toStringAsFixed(2));
    final double totalRemainingAbs = totalRemaining.abs();
    final bool isDone = order.workflowStatus == WorkflowStatus.done;
    final double finalTotalPrice = isDone 
      ? double.parse(totalPriceWithPartsPrice.toStringAsFixed(2))
      : double.parse((order.totalPriceWithVAT ?? 0).toStringAsFixed(2));
    final String sign = totalRemaining == 0 ? "" : totalRemaining < 0 ? "-" : "+";
    

    return Container(
      child: Column(
        children: <Widget>[
          PriceRow(
            title: localizations.translate(LocalizedKey.discountTitle), 
            price: order.discountPercent ?? 0,),
          PriceRow(
            title: localizations.translate(LocalizedKey.totalDiscountTitle), 
            price: order.totalDiscountAmount ?? 0,),
          PriceRow(
            title: localizations.translate(LocalizedKey.estimatedTotalTitle), 
            price: totalPrice,),
          PriceRow(
            title: '${localizations.translate(LocalizedKey.vatTitle)} (%${order.vatPercentage ?? 5})', 
            price: order.vatTotal ?? 0,),
          isDone 
            ? Column(
                children: <Widget>[
                  PriceRow(
                    title: AppLocalizations.of(context).translate(LocalizedKey.adminFeesTitle), 
                    price: order.partsFees ?? 0,),
                  PriceRow(
                    title: AppLocalizations.of(context).translate(LocalizedKey.partsTotalPriceTitle), 
                    price: order.adminFees ?? 0,),
                ],
              )
            : Container(),
          order.adminDiscount != null 
            ? PriceRow(
              title: localizations.translate(LocalizedKey.adminDiscountTitle), 
              price: order.adminDiscount!,)
            : Container(),
          PriceRow(
            title: localizations.translate(LocalizedKey.totalPriceTitle), 
            price: finalTotalPrice,),
          isDone 
            ? Column(
                children: <Widget>[
                  PriceRow(
                    title: AppLocalizations.of(context).translate(LocalizedKey.totalPaidTitle), 
                    price: order.totalMoneyReceived ?? 0,),
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
  const ExtraPriceInfo({super.key, required this.order});
  
  final OrderInfo order;

  @override
  Widget build(BuildContext context) {
    final double totalRemaining = 
      double.parse((order.totalMoneyReceived ?? 0).toStringAsFixed(2)) - 
      double.parse((order.totalPriceWithVAT ?? 0).toStringAsFixed(2));
    return Container(
      child: Column(
        children: <Widget>[
          PriceRow(
            title: AppLocalizations.of(context).translate(LocalizedKey.adminFeesTitle), 
            price: order.partsFees ?? 0,),
          PriceRow(
            title: AppLocalizations.of(context).translate(LocalizedKey.partsTotalPriceTitle), 
            price: order.adminFees ?? 0,),
          PriceRow(
            title: AppLocalizations.of(context).translate(LocalizedKey.totalPaidTitle), 
            price: order.totalMoneyReceived ?? 0,),
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
  const PriceRow({super.key, required this.title, required this.price, this.intSign = ""});

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
