import 'package:cloud_firestore/cloud_firestore.dart';

class OrderInfo{
  String documentID;
  String id;
  String username;
  String userPhone;
  String orderStatus;
  String workflowStatus;
  DateTime dateCreated;
  DateTime dateUpdate;
  List<OrderService> orderService;
  List<String> imagesUrl;
  String comment;
  String visitTime;
  DateTime visitDate;
  num visiteDateTimestamp;
  DateTime visitDateAndTime;
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
  bool reminderOnDay;
  bool reminderOneHour;
  num totalMoneyReceived;
  num partsFees;
  num adminFees;
  num vatPercentage;
  String paymentMethod;

  OrderInfo({this.documentID ,this.id, this.username, this.userPhone, this.orderStatus, this.workflowStatus, this.dateCreated, this.orderService, this.imagesUrl, this.comment, this.visitDate , this.visitTime, this.coordinate, this.discountPercent, this.totalDiscountAmount, this.totalPriceAfterDiscount, this.totalPriceBeforeDiscount, this.totalPriceWithVAT, this.vatTotal, this.visiteDateTimestamp,
  this.adminID, this.adminName, this.adminRole, this.cancelReason, this.changeRequestDetails, this.visitDateAndTime, this.dateUpdate, this.reminderOnDay, this.reminderOneHour, this.partsFees, this.adminFees, this.totalMoneyReceived, this.vatPercentage, this.paymentMethod});

  _orderMapToList(DocumentSnapshot orderDocData){
    Map<String, dynamic> orderData = orderDocData.data;
      int dateCreated = orderData["order_date_created"];
      int dateUpdate = orderData["order_date_updated"];
      int visitedDate = orderData["visit_date"];
      int visitDateAndTimeTimestamp = orderData["visit_date_and_time"];
      DateTime visitDateAndTime = 
        visitDateAndTimeTimestamp != null 
        ? DateTime.fromMillisecondsSinceEpoch(visitDateAndTimeTimestamp)
        : null;

      this.documentID = orderDocData.documentID;
      this.id = orderData["order_id"];
      this.username = orderData["username"];
      this.userPhone = orderData["user_phone"];
      this.orderStatus = orderData["order_status"];
      this.workflowStatus = orderData["workflow_status"];
      this.dateCreated = DateTime.fromMillisecondsSinceEpoch(dateCreated);
      this.dateUpdate = DateTime.fromMillisecondsSinceEpoch(dateUpdate);
      this.visitDate = DateTime.fromMillisecondsSinceEpoch(visitedDate);
      this.visiteDateTimestamp = visitedDate;
      this.visitTime = orderData["visit_time"];
      this.visitDateAndTime = visitDateAndTime;
      this.comment = orderData["comment"];
      this.discountPercent = orderData["discount_percent"];
      this.totalDiscountAmount = orderData["total_discount_amount"];
      this.totalPriceBeforeDiscount = orderData["total_order_price"];
      this.totalPriceAfterDiscount = orderData["total_order_price_after_discount"];
      this.vatTotal = orderData["VAT_total"];
      this.totalPriceWithVAT = orderData["total_price_with_VAT"];
      this.coordinate = Coordinate.fromMap(orderData["visit_location"]);
      this.adminID = orderData["admin_id"];
      this.adminName = orderData["admin_name"];
      this.adminRole = orderData["admin_role"];
      this.cancelReason = orderData["cancel_reason"];
      this.changeRequestDetails = orderData["change_request_details"];
      this.reminderOnDay = orderData["one_day_reminder"];
      this.reminderOneHour = orderData["one_hour_reminder"];
      this.totalMoneyReceived = orderData["money_received"];
      this.adminFees = orderData["parts_total"];
      this.partsFees = orderData["administrative_fees"];
      this.vatPercentage = orderData["vat_percentage"];
      this.paymentMethod = orderData["payment_method"];

      List<dynamic> serviceList = orderData["order_services"];
      this.orderService = List<OrderService>();
      serviceList.forEach((serv) {
        this.orderService.add(OrderService.fromMap(serv));
      });

      Map<dynamic, dynamic> imagesUrlMap = orderData["images_url"];
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
    // TODO: From order list to map.
  }

  update(OrderInfo order){
    this.documentID = order.documentID;
    this.id = order.id;
    this.username = order.username;
    this.userPhone = order.userPhone;
    this.orderStatus = order.orderStatus;
    this.workflowStatus = order.workflowStatus;
    this.dateCreated = order.dateCreated;
    this.visitDate = order.visitDate;
    this.visiteDateTimestamp = order.visiteDateTimestamp;
    this.visitTime = order.visitTime;
    this.visitDateAndTime = order.visitDateAndTime;
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
    this.reminderOnDay = order.reminderOnDay;
    this.reminderOneHour = order.reminderOneHour;
    this.totalMoneyReceived = order.totalMoneyReceived;
    this.adminFees = order.adminFees;
    this.partsFees = order.partsFees;
    this.vatPercentage = order.vatPercentage;
  }
}

class Coordinate{
  num latitude;
  num logntitude;

  Coordinate.fromMap(Map<dynamic, dynamic> location){
    this.latitude = location["latitude"];
    this.logntitude = location["longitude"];
  }
}

class OrderService{
  String serviceCategoryId;
  String mainServiceId;
  String subMainServiceId;
  bool isSubService;
  String nameAr;
  String nameEn;
  num priceForOnePiece;
  num total;
  num quantity;
  bool neededParts;
  bool isDeleted = false;

  OrderService({this.serviceCategoryId, this.mainServiceId, this.subMainServiceId, this.isSubService, this.nameAr, this.nameEn, this.priceForOnePiece, this.total, this.quantity, this.neededParts});

  OrderService.fromMap(Map<dynamic, dynamic> service){
    this.serviceCategoryId = service["service_category_id"];
    this.mainServiceId = service["main_service_id"];
    this.subMainServiceId = service["sub_main_service_id"];
    this.isSubService = service["is_sub_main_service"];
    this.nameAr = service["service_name_ar"];
    this.nameEn = service["service_name_en"];
    this.priceForOnePiece = service["price_for_one_piece"];
    this.total = service["total_price"];
    this.quantity = service["quantity"];
    this.neededParts = service["needed_parts"];
  }

  update(OrderService serv){
    this.serviceCategoryId = serv.serviceCategoryId;
    this.nameAr = serv.nameAr;
    this.nameEn = serv.nameEn;
    this.priceForOnePiece = serv.priceForOnePiece;
    this.total = serv.total;
    this.quantity = serv.quantity;
    this.neededParts = serv.neededParts;
  }
}