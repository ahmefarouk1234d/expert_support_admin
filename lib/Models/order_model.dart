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

  OrderInfo({this.documentID ,this.id, this.username, this.userPhone, this.orderStatus, this.workflowStatus, this.dateCreated, this.orderService, this.imagesUrl, this.comment, this.visitDate , this.visitTime, this.coordinate, this.discountPercent, this.totalDiscountAmount, this.totalPriceAfterDiscount, this.totalPriceBeforeDiscount, this.totalPriceWithVAT, this.vatTotal, this.visiteDateTimestamp,
  this.adminID, this.adminName, this.adminRole, this.cancelReason, this.changeRequestDetails, this.visitDateAndTime, this.dateUpdate, this.reminderOnDay, this.reminderOneHour});

  _orderMapToList(DocumentSnapshot orderDocData){
    Map<String, dynamic> orderData = orderDocData.data;
      int dateCreated = orderData["OrderDateCreated"];
      int dateUpdate = orderData["OrderDateUpdated"];
      int visitedDate = orderData["VisitDate"];
      int visitDateAndTimeTimestamp = orderData["VisitDateAndTime"];
      DateTime visitDateAndTime = 
        visitDateAndTimeTimestamp != null 
        ? DateTime.fromMillisecondsSinceEpoch(visitDateAndTimeTimestamp)
        : null;

      this.documentID = orderDocData.documentID;
      this.id = orderData["orderID"];
      this.username = orderData["username"];
      this.userPhone = orderData["userPhone"];
      this.orderStatus = orderData["OrderStatus"];
      this.workflowStatus = orderData["WorkflowStatus"];
      this.dateCreated = DateTime.fromMillisecondsSinceEpoch(dateCreated);
      this.dateUpdate = DateTime.fromMillisecondsSinceEpoch(dateUpdate);
      this.visitDate = DateTime.fromMillisecondsSinceEpoch(visitedDate);
      this.visiteDateTimestamp = visitedDate;
      this.visitTime = orderData["VisitTime"];
      this.visitDateAndTime = visitDateAndTime;
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
      this.reminderOnDay = orderData["OneDayReminder"];
      this.reminderOneHour = orderData["OneHourReminder"];

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
  String serviceCategoryId;
  String mainServiceId;
  String subMainServiceId;
  bool isSubService;
  String nameAr;
  String nameEn;
  num priceForOnePiece;
  num total;
  num quantity;
  bool hasParts;

  OrderService({this.serviceCategoryId, this.mainServiceId, this.subMainServiceId, this.isSubService, this.nameAr, this.nameEn, this.priceForOnePiece, this.total, this.quantity, this.hasParts});

  OrderService.fromMap(Map<dynamic, dynamic> service){
    this.serviceCategoryId = service["serviceCategoryID"];
    this.mainServiceId = service["mainServiceID"];
    this.subMainServiceId = service["subMainServiceID"];
    this.isSubService = service["isSubMainService"];
    this.nameAr = service["serviceNameAr"];
    this.nameEn = service["serviceNameEn"];
    this.priceForOnePiece = service["priceForOnePiece"];
    this.total = service["totalPrice"];
    this.quantity = service["Quantity"];
    this.hasParts = service["HasParts"];
  }

  update(OrderService serv){
    this.serviceCategoryId = serv.serviceCategoryId;
    this.nameAr = serv.nameAr;
    this.nameEn = serv.nameEn;
    this.priceForOnePiece = serv.priceForOnePiece;
    this.total = serv.total;
    this.quantity = serv.quantity;
    this.hasParts = serv.hasParts;
  }
}