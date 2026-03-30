import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/discount_model.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/offer_status.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';

class DataBase {
  static const bool isTestMode = false;

  final adminUserCollection =
      FirebaseFirestore.instance.collection("AdminUser");
  final offerCollection = FirebaseFirestore.instance.collection("Offers");

  final servicesCollection =
      FirebaseFirestore.instance.collection("ServiceList");
  final servicesTestCollectoion =
      FirebaseFirestore.instance.collection("ServiceListTest");

  final ordersCollection = FirebaseFirestore.instance.collection("OrdersList");
  final ordersTestCollectoion =
      FirebaseFirestore.instance.collection("OrdersListTest");

  final orderOfferCollection =
      FirebaseFirestore.instance.collection("OrderOffers");
  final offersListTestCollectoion =
      FirebaseFirestore.instance.collection("OrderOffersTest");

  final generalDetailsCollection =
      FirebaseFirestore.instance.collection("GeneralDetails");
  final generalDetailsTestCollection =
      FirebaseFirestore.instance.collection("GeneralDetailsTest");

  final dateAvailabilityCollection =
      FirebaseFirestore.instance.collection("DateAvailabilityLog");
  final dateAvailabilityTestCollection =
      FirebaseFirestore.instance.collection("DateAvailabilityLogTest");

  final discountCollection = FirebaseFirestore.instance.collection("Discount");
  final discountTestCollection =
      FirebaseFirestore.instance.collection("DiscountTest");

  Future<void> saveAdminUser(AdminUserInfo admin) {
    Map<String, dynamic> adminUserMap = AdminUserInfo().toMap(admin);
    return adminUserCollection.doc(admin.id).set(adminUserMap);
  }

  Future<void> updateAdminUser(AdminUserInfo admin) {
    Map<String, dynamic> adminUserMap = AdminUserInfo().toUpdateInfoMap(admin);
    return adminUserCollection.doc(admin.id).update(adminUserMap);
  }

  Future<void> deleteAdminUser(AdminUserInfo admin) {
    Map<String, dynamic> adminUserMap = AdminUserInfo().toDeletedInfoMap(admin);
    return adminUserCollection.doc(admin.id).update(adminUserMap);
  }

  Stream<QuerySnapshot> getPendingOrders(int? fromDate, int? toDate) {
    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    Query orderQuery = collectionReference.where("workflow_status",
        whereIn: [WorkflowStatus.pending, WorkflowStatus.requestChange]);
    Stream<QuerySnapshot> orders;

    if (fromDate != null && toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    } else if (fromDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .orderBy("visit_date", descending: true);
    } else if (toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    }

    orders =
        orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getInProcessOrders(int? fromDate, int? toDate) {
    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    Query orderQuery = collectionReference.where("workflow_status", whereIn: [
      WorkflowStatus.inProcess,
      WorkflowStatus.requestChangeReply,
      WorkflowStatus.onTheWay,
      WorkflowStatus.arrived
    ]);
    Stream<QuerySnapshot> orders;

    if (fromDate != null && toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    } else if (fromDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .orderBy("visit_date", descending: true);
    } else if (toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    }

    orders =
        orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getDoneOrders(int? fromDate, int? toDate) {
    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    Query orderQuery = collectionReference.where("workflow_status",
        isEqualTo: WorkflowStatus.done);
    Stream<QuerySnapshot> orders;

    if (fromDate != null && toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    } else if (fromDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .orderBy("visit_date", descending: true);
    } else if (toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    }

    orders =
        orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getCanceledOrders(int? fromDate, int? toDate) {
    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    Query orderQuery = collectionReference.where("workflow_status",
        isEqualTo: WorkflowStatus.canceled);
    Stream<QuerySnapshot> orders;

    if (fromDate != null && toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    } else if (fromDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .orderBy("visit_date", descending: true);
    } else if (toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    }

    orders =
        orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getOrders(int? fromDate, int? toDate) {
    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    Query orderQuery = collectionReference.where("workflow_status", whereIn: [
      WorkflowStatus.pending,
      WorkflowStatus.requestChange,
      WorkflowStatus.inProcess,
      WorkflowStatus.requestChangeReply,
      WorkflowStatus.done,
      WorkflowStatus.canceled,
      WorkflowStatus.onTheWay,
      WorkflowStatus.arrived
    ]);
    Stream<QuerySnapshot> orders;

    if (fromDate != null && toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    } else if (fromDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isGreaterThanOrEqualTo: fromDate)
          .orderBy("visit_date", descending: true);
    } else if (toDate != null) {
      orderQuery = orderQuery
          .where("visit_date", isLessThanOrEqualTo: toDate)
          .orderBy("visit_date", descending: true);
    }

    orders =
        orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Future<void> updateOrderStatus(OrderInfo order, AdminUserInfo admin,
      {String? cancelReason, String? changeRequestDetails}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    CollectionReference dateLogCollectionReference = isTestMode
        ? dateAvailabilityTestCollection
        : dateAvailabilityCollection;

    DocumentReference ordersDocRef = collectionReference.doc(order.documentID);
    batch.update(ordersDocRef, {
      "order_status": order.orderStatus,
      "workflow_status": order.workflowStatus,
      "last_workflow_status": order.lastWorkflowStatus,
      "last_tech_workflow_status": order.lastTechWorkflowStatus,
      "admin_name": admin.name,
      "admin_id": admin.id,
      "admin_role": admin.role,
      "cancel_reason": cancelReason,
      "change_request_details": changeRequestDetails,
      "money_received": order.totalMoneyReceived,
      "parts_total": order.adminFees,
      "administrative_fees": order.partsFees,
      "order_date_updated": DateTime.now().toUtc().millisecondsSinceEpoch,
    });

    DocumentReference ordersDocWorkflowRef =
        ordersDocRef.collection("workflow").doc();
    batch.set(ordersDocWorkflowRef, {
      "workflow_status": order.workflowStatus,
      "admin_name": admin.name,
      "admin_id": admin.id,
      "admin_role": admin.role,
      "cancel_reason": cancelReason,
      "change_request_details": changeRequestDetails,
      "date_created": DateTime.now().toUtc().millisecondsSinceEpoch,
    });

    if (order.workflowStatus == WorkflowStatus.canceled) {
      QuerySnapshot dateLogQuesryForSelectedTimestamp =
          await dateLogCollectionReference
              .where("timestamp", isEqualTo: order.visiteDateTimestamp)
              .get();

      if (dateLogQuesryForSelectedTimestamp.docs.isNotEmpty) {
        final DocumentReference dateAvailabilityDoc =
            dateLogCollectionReference.doc("${order.visiteDateTimestamp}");
        for (var s in order.orderService!) {
          batch.update(dateAvailabilityDoc, <String, dynamic>{
            s.serviceCategoryId!: FieldValue.arrayRemove([order.documentID])
          });
        }
      }
    }

    return batch.commit();
  }

  Future<void> updateServices(OrderInfo order, String docId) {
    Map<String, dynamic> updatedOrderMap = {};
    List<Map<String, dynamic>> servicesMap = [];

    for (var s in order.orderService!) {
      Map<String, dynamic> serv = {};
      serv = {
        "needed_parts": s.neededParts,
        "quantity": s.quantity,
        "is_sub_main_service": s.isSubService,
        "main_service_id": s.mainServiceId,
        "price_for_one_piece": s.priceForOnePiece,
        "service_category_id": s.serviceCategoryId,
        "service_name_ar": s.nameAr,
        "service_name_en": s.nameEn,
        "sub_main_service_id": s.subMainServiceId,
        "total_price": s.total
      };
      servicesMap.add(serv);
    }

    updatedOrderMap = {
      "order_services": servicesMap,
      "order_date_updated": DateTime.now().toUtc().millisecondsSinceEpoch,
      "total_discount_amount": order.totalDiscountAmount,
      "total_order_price": order.totalPriceBeforeDiscount,
      "total_order_price_after_discount": order.totalPriceAfterDiscount,
      "VAT_total": order.vatTotal,
      "total_price_with_VAT": order.totalPriceWithVAT,
    };

    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    return collectionReference.doc(docId).update(updatedOrderMap);
  }

  Future<void> updateOrderAdminDiscount(OrderInfo order, AdminUserInfo admin) {
    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    DocumentReference ordersDocRef = collectionReference.doc(order.documentID);
    return ordersDocRef.update({
      "admin_discount": order.adminDiscount,
      "discount_made_by_name": admin.name,
      "discount_made_by_role": admin.role,
      "discount_made_by_id": admin.id,
      "total_order_price_after_discount": order.totalPriceAfterDiscount,
      "VAT_total": order.vatTotal,
      "total_price_with_VAT": order.totalPriceWithVAT,
      'old_total_price_before_admin_discount':
          order.oldTotalPriceBeforeAdminDiscount
    });
  }

  Future<void> updateTimeDate(OrderInfo order, String docId) {
    Map<String, dynamic> updatedOrderMap = {};
    updatedOrderMap = {
      "visit_date": order.visitDate!.millisecondsSinceEpoch,
      "visit_time": order.visitTime,
      "visit_date_and_time": order.visitDateAndTime!.millisecondsSinceEpoch
    };

    CollectionReference collectionReference =
        isTestMode ? ordersTestCollectoion : ordersCollection;
    return collectionReference.doc(docId).update(updatedOrderMap);
  }

  Future<QuerySnapshot> getServices() {
    CollectionReference collectionReference =
        isTestMode ? servicesTestCollectoion : servicesCollection;
    return collectionReference.orderBy("Order").get();
  }

  Stream<QuerySnapshot> getServicesStream() {
    CollectionReference collectionReference =
        isTestMode ? servicesTestCollectoion : servicesCollection;
    return collectionReference.orderBy("Order").snapshots();
  }

  Future<void> updateServiceActiveStatus(String docId, bool isActive) {
    CollectionReference collectionReference =
        isTestMode ? servicesTestCollectoion : servicesCollection;
    return collectionReference.doc(docId).update({"IsActive": isActive});
  }

  Future<DocumentSnapshot> getAdminInfo(String adminID) {
    return adminUserCollection.doc(adminID).get();
  }

  Future<void> updateFcmToken(String adminID, String token) {
    return adminUserCollection.doc(adminID).update({"fcm_token": token});
  }

  Stream<QuerySnapshot> getAllUsers() {
    return adminUserCollection.snapshots();
  }

  Future<void> saveOffer(OfferInfo offer) {
    Map<String, dynamic> offerMap = OfferInfo().toMapOnCreate(offer);
    return offerCollection.doc().set(offerMap);
  }

  Future<void> updateAllOffer(OfferInfo offer) {
    Map<String, dynamic> offerMap = OfferInfo().toMapOnUpdateAll(offer);
    return offerCollection.doc(offer.offerID).update(offerMap);
  }

  Future<void> updateOfferStatus(OfferInfo offer) {
    Map<String, dynamic> offerMap = OfferInfo().toMapOnUpdateStatus(offer);
    return offerCollection.doc(offer.offerID).update(offerMap);
  }

  Stream<QuerySnapshot> getAllOffers() {
    return offerCollection.orderBy("date_update", descending: true).snapshots();
  }

  Future<void> saveOrderOffer(OrderOfferInfo offer) {
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnCreate(offer);

    CollectionReference collectionReference =
        isTestMode ? offersListTestCollectoion : orderOfferCollection;
    return collectionReference.doc().set(offerMap);
  }

  Future<void> updateAllOrderOffer(OrderOfferInfo offer) {
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnUpdateAll(offer);
    CollectionReference collectionReference =
        isTestMode ? offersListTestCollectoion : orderOfferCollection;
    return collectionReference.doc(offer.id).update(offerMap);
  }

  Future<void> updateOrderOfferStatus(OrderOfferInfo offer) {
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnUpdateStatus(offer);

    CollectionReference collectionReference =
        isTestMode ? offersListTestCollectoion : orderOfferCollection;
    return collectionReference.doc(offer.id).update(offerMap);
  }

  Stream<QuerySnapshot> getAllOrderOffers() {
    CollectionReference collectionReference =
        isTestMode ? offersListTestCollectoion : orderOfferCollection;
    return collectionReference
        .where("status", whereIn: [OfferStatus.active, OfferStatus.deactive])
        .orderBy("date_update", descending: true)
        .snapshots();
  }

  Future<void> saveDiscountCode(DiscountInfo discountInfo) {
    Map<String, dynamic> discountInfoMap =
        DiscountInfo().toMapOnCreate(discountInfo);

    CollectionReference collectionReference =
        isTestMode ? discountTestCollection : discountCollection;
    return collectionReference.doc().set(discountInfoMap);
  }

  Stream<QuerySnapshot> getAllDiscountCode() {
    CollectionReference collectionReference =
        isTestMode ? discountTestCollection : discountCollection;
    return collectionReference.snapshots();
  }

  Future<void> updateDiscountCode(DiscountInfo discount) {
    Map<String, dynamic> discountMap =
        DiscountInfo().toMapOnUpdateStatus(discount);

    CollectionReference collectionReference =
        isTestMode ? discountTestCollection : discountCollection;
    return collectionReference.doc(discount.id).update(discountMap);
  }

  Stream<QuerySnapshot> getGeneralDetails() {
    CollectionReference collectionReference =
        isTestMode ? generalDetailsTestCollection : generalDetailsCollection;
    return collectionReference.snapshots();
  }

  Future<SubmitOrder> getSubmittedOrderGeneralDetails() async {
    CollectionReference collectionReference =
        isTestMode ? generalDetailsTestCollection : generalDetailsCollection;
    DocumentSnapshot doc = await collectionReference.doc("SubmitOrder").get();
    return SubmitOrder.fromDocumentSnapshot(doc);
  }

  Future<void> updateAboutUsGeneralDetails(AboutUs aboutUs) {
    Map<String, dynamic> dataMap = AboutUs().toMapOnUpdate(aboutUs);
    CollectionReference collectionReference =
        isTestMode ? generalDetailsTestCollection : generalDetailsCollection;

    return collectionReference.doc("ContactUs").update(dataMap);
  }

  Future<void> updateSharedGeneralDetails(Shared shared) {
    Map<String, dynamic> dataMap = Shared().toMapOnUpdate(shared);
    CollectionReference collectionReference =
        isTestMode ? generalDetailsTestCollection : generalDetailsCollection;

    return collectionReference.doc("Shared").update(dataMap);
  }

  Future<void> updateSubmitOrderGeneralDetails(SubmitOrder submitOrder) {
    Map<String, dynamic> dataMap = SubmitOrder().toMapOnUpdate(submitOrder);
    CollectionReference collectionReference =
        isTestMode ? generalDetailsTestCollection : generalDetailsCollection;

    return collectionReference.doc("SubmitOrder").update(dataMap);
  }

  Future<void> updateOrderLimitGeneralDetails(OrderLimit orderLimit) {
    Map<String, dynamic> dataMap = OrderLimit().toMapOnUpdate(orderLimit);
    CollectionReference collectionReference =
        isTestMode ? generalDetailsTestCollection : generalDetailsCollection;

    return collectionReference.doc("orderLimit").update(dataMap);
  }
}
