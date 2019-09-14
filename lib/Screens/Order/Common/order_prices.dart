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

    return Container(
      child: Column(
        children: <Widget>[
          PriceRow(title: "Discount", price: order.discountPercent,),
          PriceRow(title: "Total Discount", price: order.totalDiscountAmount,),
          PriceRow(title: "Estimated Total", price: totalPrice,),
          PriceRow(title: "VAT (5%)", price: order.vatTotal,),
          PriceRow(title: "Total Price", price: order.totalPriceWithVAT,),
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
      child: Row(
            children: <Widget>[
              Expanded(child: Text(title),),
              Container(width: 8,),
              Text("$price"),
            ],
          ),
    );
  }
}