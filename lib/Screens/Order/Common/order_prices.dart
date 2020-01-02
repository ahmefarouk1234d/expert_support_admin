import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/order_model.dart';
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

    return Container(
      child: Column(
        children: <Widget>[
          PriceRow(
            title: localizations.translate(LocalizedKey.discountTitle), 
            price: order.discountPercent,),
          PriceRow(
            title: localizations.translate(LocalizedKey.totalDiscountTitle), 
            price: order.totalDiscountAmount,),
          PriceRow(
            title: localizations.translate(LocalizedKey.estimatedTotalTitle), 
            price: totalPrice,),
          PriceRow(
            title: localizations.translate(LocalizedKey.vatTitle), 
            price: order.vatTotal,),
          PriceRow(
            title: localizations.translate(LocalizedKey.totalPriceTitle), 
            price: order.totalPriceWithVAT,),
        ],
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String title;
  final num price;
  PriceRow({@required this.title, @required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
            children: <Widget>[
              Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w700),),),
              Container(width: 8,),
              Text("${price.toStringAsFixed(2)}"), //toStringAsFixed(2) to show two decimal point.
            ],
          ),
    );
  }
}