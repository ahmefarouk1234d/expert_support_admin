import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';

class OrderInfo{
  String documentID;
  String id;
  String username;
  String userPhone;
  String status;
  String dateCreated;
  List<OrderService> orderService;
  List<String> imagesUrl;
  String comment;
  String visitTime;
  DateTime visitDate;
  String visitDateFormatted;
  Coordinate coordinate;
  num discountPercent;
  num totalDiscountAmount;
  num totalPriceBeforeDiscount;
  num totalPriceAfterDiscount;
  num vatTotal;
  num totalPriceWithVAT;
  String adminID;
  String adminName;
  String adminRole;
  String cancelReason;
  String changeRequestDetails;

  OrderInfo({this.documentID ,this.id, this.username, this.userPhone, this.status, this.dateCreated, this.orderService, this.imagesUrl, this.comment, this.visitDate , this.visitDateFormatted, this.visitTime, this.coordinate, this.discountPercent, this.totalDiscountAmount, this.totalPriceAfterDiscount, this.totalPriceBeforeDiscount, this.totalPriceWithVAT, this.vatTotal,
  this.adminID, this.adminName, this.adminRole, this.cancelReason, this.changeRequestDetails});

  _orderMapToList(DocumentSnapshot orderDocData){
    Map<String, dynamic> orderData = orderDocData.data;
      int dateCreated = orderData["OrderDateCreated"];
      int visitedDate = orderData["VisitDate"];

      this.documentID = orderDocData.documentID;
      this.id = orderData["orderID"];
      this.username = orderData["username"];
      this.userPhone = orderData["userPhone"];
      this.status = orderData["OrderStatus"];
      this.dateCreated = DateConvert().toStringFromTimestamp(timestamp: dateCreated);
      this.visitDateFormatted = DateConvert().toStringFromTimestamp(timestamp: visitedDate);
      this.visitDate = DateTime.fromMillisecondsSinceEpoch(visitedDate);
      this.visitTime = orderData["VisitTime"];
      this.comment = orderData["Comment"];
      this.discountPercent = orderData["DiscountPercent"];
      this.totalDiscountAmount = orderData["TotalDiscountAmount"];
      this.totalPriceBeforeDiscount = orderData["TotalOrderPrice"];
      this.totalPriceAfterDiscount = orderData["TotalOrderPriceAfterDiscount"];
      this.vatTotal = orderData["VATTotal"];
      this.totalPriceWithVAT = orderData["TotalPriceWithVAT"];
      this.coordinate = Coordinate.fromMap(orderData["VisitLocation"]);
      this.adminID = orderData["adminID"];
      this.adminName = orderData["adminName"];
      this.adminRole = orderData["adminRole"];
      this.cancelReason = orderData["cancelReason"];
      this.changeRequestDetails = orderData["changeRequestDetails"];

      List<dynamic> serviceList = orderData["OrderServices"];
      this.orderService = List<OrderService>();
      serviceList.forEach((serv) {
        this.orderService.add(OrderService.fromMap(serv));
      });

      Map<dynamic, dynamic> imagesUrlMap = orderData["ImagesUrl"];
      this.imagesUrl = List();
      imagesUrlMap.forEach((key, value){
        this.imagesUrl.add(value);
      });
  }

  OrderInfo.fromMap({DocumentSnapshot orderDocData}){
      this._orderMapToList(orderDocData);
  }

  static List<OrderInfo> fromMapList({List<DocumentSnapshot> orderDocDataList}){
    List<OrderInfo> orderList = List();
    orderDocDataList.forEach((orderDocData){
      orderList.add(OrderInfo().._orderMapToList(orderDocData));
    });
    return orderList;
  }

  OrderInfo.toMap(){
    //TODO: From order list to map.
  }

  update(OrderInfo order){
    this.documentID = order.documentID;
    this.id = order.id;
    this.username = order.username;
    this.userPhone = order.userPhone;
    this.status = order.status;
    this.dateCreated = order.dateCreated;
    this.visitDateFormatted = order.visitDateFormatted;
    this.visitDate = order.visitDate;
    this.visitTime = order.visitTime;
    this.comment = order.comment;
    this.discountPercent = order.discountPercent;
    this.totalDiscountAmount = order.totalDiscountAmount;
    this.totalPriceBeforeDiscount = order.totalPriceBeforeDiscount;
    this.totalPriceAfterDiscount = order.totalPriceAfterDiscount;
    this.vatTotal = order.vatTotal;
    this.totalPriceWithVAT = order.totalPriceWithVAT;
    this.coordinate = order.coordinate;
    this.orderService = List<OrderService>();
    order.orderService.forEach((serv) => this.orderService.add(OrderService()..update(serv)));
    this.imagesUrl = order.imagesUrl;
    this.adminID = order.adminID;
    this.adminName = order.adminName;
    this.adminRole = order.adminRole;
    this.cancelReason = order.cancelReason;
    this.changeRequestDetails = order.changeRequestDetails;
  }
}

class Coordinate{
  num latitude;
  num logntitude;

  Coordinate.fromMap(Map<dynamic, dynamic> location){
    this.latitude = location["Latitude"];
    this.logntitude = location["Longitude"];
  }
}

class OrderService{
  String id;
  String nameAr;
  String nameEn;
  num priceForOnePiece;
  num total;
  num quantity;
  bool hasParts;

  OrderService({this.id, this.nameAr, this.nameEn, this.priceForOnePiece, this.total, this.quantity, this.hasParts});

  OrderService.fromMap(Map<dynamic, dynamic> service){
    this.id = service["serviceID"];
    this.nameAr = service["serviceNameAr"];
    this.nameEn = service["serviceNameEn"];
    this.priceForOnePiece = service["priceForOnePiece"];
    this.total = service["totalPrice"];
    this.quantity = service["Quantity"];
    this.hasParts = service["IsPartNeededAvailable"];
  }

  update(OrderService serv){
    this.id = serv.id;
    this.nameAr = serv.nameAr;
    this.nameEn = serv.nameEn;
    this.priceForOnePiece = serv.priceForOnePiece;
    this.total = serv.total;
    this.quantity = serv.quantity;
    this.hasParts = serv.hasParts;
  }
}