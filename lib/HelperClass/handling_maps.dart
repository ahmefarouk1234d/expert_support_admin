import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';

class MapsToObject {
  List<OrderInfo> toOrderList(
      {@required List<DocumentSnapshot> orderDocDataList}) {
    List<OrderInfo> orderList = List<OrderInfo>();
    orderDocDataList.forEach((orderDocData) {
      OrderInfo order = OrderInfo();

      order.documentID = orderDocData.documentID;
      Map<String, dynamic> orderData = orderDocData.data;
      int dateCreated = orderData["OrderDateCreated"];
      int visitedDate = orderData["VisitDate"];

      order.id = orderData["orderID"];
      order.username = orderData["username"];
      order.userPhone = orderData["userPhone"];
      order.status = orderData["OrderStatus"];
      order.dateCreated = DateConvert().toStringFromTimestamp(timestamp: dateCreated);
      order.visitDate = DateConvert().toStringFromTimestamp(timestamp: visitedDate);
      order.visitTime = orderData["VisitTime"];
      order.comment = orderData["Comment"];
      order.discountPercent = orderData["DiscountPercent"];
      order.totalDiscountAmount = orderData["TotalDiscountAmount"];
      order.totalPriceBeforeDiscount = orderData["TotalOrderPrice"];
      order.totalPriceAfterDiscount = orderData["TotalOrderPriceAfterDiscount"];
      order.vatTotal = orderData["VATTotal"];
      order.totalPriceWithVAT = orderData["TotalPriceWithVAT"];

      // Map<dynamic, dynamic> location = orderData["VisitLocation"];
      // Coordinate coordinate = Coordinate();
      // coordinate.latitude = location["Latitude"];
      // coordinate.logntitude = location["Longitude"];
      // order.coordinate = coordinate;

      // List<dynamic> serviceList = orderData["OrderServices"];
      // order.orderService = List<OrderService>();
      // serviceList.forEach((serv) {
      //   OrderService orderServ = OrderService();
      //   orderServ.id = serv["serviceID"];
      //   orderServ.nameAr = serv["serviceNameAr"];
      //   orderServ.nameEn = serv["serviceNameEn"];
      //   orderServ.priceForOnePiece = serv["priceForOnePiece"];
      //   orderServ.total = serv["totalPrice"];
      //   orderServ.quantity = serv["Quantity"];
      //   orderServ.hasParts = serv["IsPartNeededAvailable"];

      //   order.orderService.add(orderServ);
      // });

      orderList.add(order);
    });

    return orderList;
  }
}
