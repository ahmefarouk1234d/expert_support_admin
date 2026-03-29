import 'package:cloud_firestore/cloud_firestore.dart';

class OrderInfo {
  String? documentID;
  String? id;
  String? username;
  String? userPhone;
  String? orderStatus;
  String? workflowStatus;
  String? lastWorkflowStatus;
  String? lastTechWorkflowStatus;
  DateTime? dateCreated;
  DateTime? dateUpdate;
  List<OrderService>? orderService;
  List<String>? imagesUrl;
  String? comment;
  String? visitTime;
  DateTime? visitDate;
  num? visiteDateTimestamp;
  DateTime? visitDateAndTime;
  Coordinate? coordinate;
  num? discountPercent;
  num? totalDiscountAmount;
  num? totalPriceBeforeDiscount;
  num? totalPriceAfterDiscount;
  num? vatTotal;
  num? totalPriceWithVAT;
  String? adminID;
  String? adminName;
  String? adminRole;
  String? cancelReason;
  String? changeRequestDetails;
  bool? reminderOnDay;
  bool? reminderOneHour;
  num? totalMoneyReceived;
  num? partsFees;
  num? adminFees;
  num? vatPercentage;
  String? paymentMethod;
  num? adminDiscount;
  String? discountMadeByName;
  String? discountMadeByRole;
  String? discountMadeByID;
  num? oldTotalPriceBeforeAdminDiscount;

  OrderInfo(
      {this.documentID,
      this.id,
      this.username,
      this.userPhone,
      this.orderStatus,
      this.workflowStatus,
      this.dateCreated,
      this.orderService,
      this.imagesUrl,
      this.comment,
      this.visitDate,
      this.visitTime,
      this.coordinate,
      this.discountPercent,
      this.totalDiscountAmount,
      this.totalPriceAfterDiscount,
      this.totalPriceBeforeDiscount,
      this.totalPriceWithVAT,
      this.vatTotal,
      this.visiteDateTimestamp,
      this.adminID,
      this.adminName,
      this.adminRole,
      this.cancelReason,
      this.changeRequestDetails,
      this.visitDateAndTime,
      this.dateUpdate,
      this.reminderOnDay,
      this.reminderOneHour,
      this.partsFees,
      this.adminFees,
      this.totalMoneyReceived,
      this.vatPercentage,
      this.paymentMethod,
      this.adminDiscount,
      this.discountMadeByName,
      this.discountMadeByRole,
      this.lastWorkflowStatus,
      this.oldTotalPriceBeforeAdminDiscount,
      this.discountMadeByID,
      this.lastTechWorkflowStatus});

  void _orderMapToList(DocumentSnapshot orderDocData) {
    Map<String, dynamic> orderData = orderDocData.data() as Map<String, dynamic>;
    int? dateCreated = orderData["order_date_created"];
    int? dateUpdate = orderData["order_date_updated"];
    int? visitedDate = orderData["visit_date"];
    int? visitDateAndTimeTimestamp = orderData["visit_date_and_time"];
    DateTime? visitDateAndTime = visitDateAndTimeTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(visitDateAndTimeTimestamp)
        : null;

    documentID = orderDocData.id;
    id = orderData["order_id"];
    username = orderData["username"];
    userPhone = orderData["user_phone"] ?? orderData["userPhone"];
    orderStatus = orderData["order_status"];
    workflowStatus = orderData["workflow_status"];
    this.dateCreated = DateTime.fromMillisecondsSinceEpoch(dateCreated!);
    this.dateUpdate = DateTime.fromMillisecondsSinceEpoch(dateUpdate!);
    visitDate = DateTime.fromMillisecondsSinceEpoch(visitedDate!);
    visiteDateTimestamp = visitedDate;
    visitTime = orderData["visit_time"];
    this.visitDateAndTime = visitDateAndTime;
    comment = orderData["comment"];
    discountPercent = orderData["discount_percent"];
    totalDiscountAmount = orderData["total_discount_amount"];
    totalPriceBeforeDiscount = orderData["total_order_price"];
    totalPriceAfterDiscount =
        orderData["total_order_price_after_discount"];
    vatTotal = orderData["VAT_total"];
    totalPriceWithVAT = orderData["total_price_with_VAT"];
    coordinate = Coordinate.fromMap(orderData["visit_location"]);
    adminID = orderData["admin_id"];
    adminName = orderData["admin_name"];
    adminRole = orderData["admin_role"];
    cancelReason = orderData["cancel_reason"];
    changeRequestDetails = orderData["change_request_details"];
    reminderOnDay = orderData["one_day_reminder"];
    reminderOneHour = orderData["one_hour_reminder"];
    totalMoneyReceived = orderData["money_received"];
    adminFees = orderData["parts_total"];
    partsFees = orderData["administrative_fees"];
    vatPercentage = orderData["vat_percentage"];
    paymentMethod = orderData["payment_method"];
    adminDiscount = orderData["admin_discount"];
    discountMadeByName = orderData["discount_made_by_name"];
    discountMadeByRole = orderData["discount_made_by_role"];
    discountMadeByID = orderData["discount_made_by_id"];
    oldTotalPriceBeforeAdminDiscount =
        orderData["old_total_price_before_admin_discount"];
    lastWorkflowStatus = orderData["last_workflow_status"];
    lastTechWorkflowStatus = orderData["last_tech_workflow_status"];

    List<dynamic> serviceList = orderData["order_services"];
    orderService = <OrderService>[];
    for (var serv in serviceList) {
      orderService!.add(OrderService.fromMap(serv));
    }

    Map<String, dynamic>? imagesUrlMap = orderData["images_url"] as Map<String, dynamic>?;
    imagesUrl = <String>[];
    if (imagesUrlMap != null) {
      imagesUrlMap.forEach((key, value) {
        imagesUrl!.add(value);
      });
    }
  }

  OrderInfo.fromMap({required DocumentSnapshot orderDocData}) {
    _orderMapToList(orderDocData);
  }

  static List<OrderInfo> fromMapList(
      {required List<DocumentSnapshot> orderDocDataList}) {
    List<OrderInfo> orderList = <OrderInfo>[];
    for (var orderDocData in orderDocDataList) {
      orderList.add(OrderInfo().._orderMapToList(orderDocData));
    }
    return orderList;
  }

  void update(OrderInfo order) {
    documentID = order.documentID;
    id = order.id;
    username = order.username;
    userPhone = order.userPhone;
    orderStatus = order.orderStatus;
    workflowStatus = order.workflowStatus;
    dateCreated = order.dateCreated;
    visitDate = order.visitDate;
    visiteDateTimestamp = order.visiteDateTimestamp;
    visitTime = order.visitTime;
    visitDateAndTime = order.visitDateAndTime;
    comment = order.comment;
    discountPercent = order.discountPercent;
    totalDiscountAmount = order.totalDiscountAmount;
    totalPriceBeforeDiscount = order.totalPriceBeforeDiscount;
    totalPriceAfterDiscount = order.totalPriceAfterDiscount;
    vatTotal = order.vatTotal;
    totalPriceWithVAT = order.totalPriceWithVAT;
    coordinate = order.coordinate;
    orderService = <OrderService>[];
    for (var serv in order.orderService!) {
      orderService!.add(OrderService()..update(serv));
    }
    imagesUrl = order.imagesUrl;
    adminID = order.adminID;
    adminName = order.adminName;
    adminRole = order.adminRole;
    cancelReason = order.cancelReason;
    changeRequestDetails = order.changeRequestDetails;
    reminderOnDay = order.reminderOnDay;
    reminderOneHour = order.reminderOneHour;
    totalMoneyReceived = order.totalMoneyReceived;
    adminFees = order.adminFees;
    partsFees = order.partsFees;
    vatPercentage = order.vatPercentage;
    paymentMethod = order.paymentMethod;
    adminDiscount = order.adminDiscount;
    discountMadeByName = order.discountMadeByName;
    discountMadeByRole = order.discountMadeByRole;
    oldTotalPriceBeforeAdminDiscount =
        order.oldTotalPriceBeforeAdminDiscount;
  }
}

class Coordinate {
  num? latitude;
  num? logntitude;

  Coordinate.fromMap(Map<String, dynamic> location) {
    latitude = location["latitude"];
    logntitude = location["longitude"];
  }
}

class OrderService {
  String? serviceCategoryId;
  String? mainServiceId;
  String? subMainServiceId;
  bool? isSubService;
  String? nameAr;
  String? nameEn;
  num? priceForOnePiece;
  num? total;
  num? quantity;
  bool? neededParts;
  bool isDeleted = false;
  String? offerServiceDetailsAr;
  String? offerServiceDetailsEn;
  bool? isPackageOffer;

  OrderService(
      {this.serviceCategoryId,
      this.mainServiceId,
      this.subMainServiceId,
      this.isSubService,
      this.nameAr,
      this.nameEn,
      this.priceForOnePiece,
      this.total,
      this.quantity,
      this.neededParts,
      this.isPackageOffer,
      this.offerServiceDetailsAr,
      this.offerServiceDetailsEn});

  OrderService.fromMap(Map<String, dynamic> service) {
    serviceCategoryId = service["service_category_id"];
    mainServiceId = service["main_service_id"];
    subMainServiceId = service["sub_main_service_id"];
    isSubService = service["is_sub_main_service"];
    nameAr = service["service_name_ar"];
    nameEn = service["service_name_en"];
    priceForOnePiece = service["price_for_one_piece"];
    total = service["total_price"];
    quantity = service["quantity"];
    neededParts = service["needed_parts"];
    offerServiceDetailsAr = service["offer_service_details_ar"];
    offerServiceDetailsEn = service["offer_dervice_details_en"];
    isPackageOffer = service["is_package_offer"];
  }

  void update(OrderService serv) {
    serviceCategoryId = serv.serviceCategoryId;
    nameAr = serv.nameAr;
    nameEn = serv.nameEn;
    priceForOnePiece = serv.priceForOnePiece;
    total = serv.total;
    quantity = serv.quantity;
    neededParts = serv.neededParts;
    offerServiceDetailsAr = serv.offerServiceDetailsAr;
    offerServiceDetailsEn = serv.offerServiceDetailsEn;
    isPackageOffer = serv.isPackageOffer;
  }
}
