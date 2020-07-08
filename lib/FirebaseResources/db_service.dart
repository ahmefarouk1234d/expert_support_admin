import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/discount_model.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/offer_status.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';

class DataBase{
  static const bool isTestMode = false;

  final adminUserCollection = Firestore.instance.collection("AdminUser");
  final offerCollection = Firestore.instance.collection("Offers");

  final servicesCollection = Firestore.instance.collection("ServiceList");
  final servicesTestCollectoion = Firestore.instance.collection("ServiceListTest");

  final ordersCollection = Firestore.instance.collection("OrdersList");
  final ordersTestCollectoion = Firestore.instance.collection("OrdersListTest");

  final orderOfferCollection = Firestore.instance.collection("OrderOffers");
  final offersListTestCollectoion = Firestore.instance.collection("OrderOffersTest");
  
  final generalDetailsCollection = Firestore.instance.collection("GeneralDetails");
  final generalDetailsTestCollection = Firestore.instance.collection("GeneralDetailsTest");

  final dateAvailabilityCollection = Firestore.instance.collection("DateAvailabilityLog");
  final dateAvailabilityTestCollection = Firestore.instance.collection("DateAvailabilityLogTest");

  final discountCollection = Firestore.instance.collection("Discount");
  final discountTestCollection = Firestore.instance.collection("DiscountTest");

  Future<void> saveAdminUser(AdminUserInfo admin) {
    Map<String, dynamic> adminUserMap = AdminUserInfo().toMap(admin);
    return adminUserCollection.document(admin.id).setData(adminUserMap);
  }

  Future<void> updateAdminUser(AdminUserInfo admin) {
    Map<String, dynamic> adminUserMap = AdminUserInfo().toUpdateInfoMap(admin);
    return adminUserCollection.document(admin.id).updateData(adminUserMap);
  }

  Future<void> deleteAdminUser(AdminUserInfo admin) {
    Map<String, dynamic> adminUserMap = AdminUserInfo().toDeletedInfoMap(admin);
    return adminUserCollection.document(admin.id).updateData(adminUserMap);
  }

  Stream<QuerySnapshot> getPendingOrders(int fromDate, int toDate){
    CollectionReference collectionReference = isTestMode 
      ? ordersTestCollectoion 
      : ordersCollection;
    Query orderQuery = collectionReference.where(
      "workflow_status", whereIn: [
        WorkflowStatus.pending, 
        WorkflowStatus.requestChange
      ]);
    Stream<QuerySnapshot> orders;
    
    if (fromDate != null && toDate != null){
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

    orders = orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getInProcessOrders(int fromDate, int toDate){
    CollectionReference collectionReference = isTestMode 
      ? ordersTestCollectoion 
      : ordersCollection;
    Query orderQuery = collectionReference.where(
      "workflow_status", whereIn: [
        WorkflowStatus.inProcess, 
        WorkflowStatus.requestChangeReply,
        WorkflowStatus.onTheWay,
        WorkflowStatus.arrived
      ]);
    Stream<QuerySnapshot> orders;

    if (fromDate != null && toDate != null){
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

    orders = orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getDoneOrders(int fromDate, int toDate){
    CollectionReference collectionReference = isTestMode 
      ? ordersTestCollectoion 
      : ordersCollection;
    Query orderQuery = collectionReference.where(
      "workflow_status", 
      isEqualTo: WorkflowStatus.done);
    Stream<QuerySnapshot> orders;

    if (fromDate != null && toDate != null){
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

    orders = orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getCanceledOrders(int fromDate, int toDate){
    CollectionReference collectionReference = isTestMode 
      ? ordersTestCollectoion 
      : ordersCollection;
    Query orderQuery = collectionReference.where(
      "workflow_status", 
      isEqualTo: WorkflowStatus.canceled);
    Stream<QuerySnapshot> orders;

    if (fromDate != null && toDate != null){
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

    orders = orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getOrders(int fromDate, int toDate){
    CollectionReference collectionReference = isTestMode 
      ? ordersTestCollectoion 
      : ordersCollection;
    Query orderQuery = collectionReference.where(
      "workflow_status", 
      whereIn: [
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
    
    if (fromDate != null && toDate != null){
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

    orders = orderQuery.orderBy("order_date_updated", descending: true).snapshots();
    return orders;
  }

  Future<void> updateOrderStatus(
    OrderInfo order, 
    AdminUserInfo admin,
    {String cancelReason,
    String changeRequestDetails}) async {

      WriteBatch batch = Firestore.instance.batch();

      CollectionReference collectionReference = isTestMode ? ordersTestCollectoion : ordersCollection;
      CollectionReference dateLogCollectionReference = isTestMode ? dateAvailabilityTestCollection : dateAvailabilityCollection;
      
      DocumentReference ordersDocRef = collectionReference.document(order.documentID);
      batch.updateData(ordersDocRef, {
        "order_status": order.orderStatus,
        "workflow_status": order.workflowStatus,
        "last_workflow_status": order.lastWorkflowStatus,
        "admin_name": admin.name,
        "admin_id": admin.id,
        "admin_role": admin.role,
        "cancel_reason": cancelReason,
        "change_request_details" : changeRequestDetails,
        "money_received" : order.totalMoneyReceived,
        "parts_total" : order.adminFees,
        "administrative_fees" : order.partsFees,
        "order_date_updated": DateTime.now().toUtc().millisecondsSinceEpoch,
      });

      DocumentReference ordersDocWorkflowRef = ordersDocRef.collection("workflow").document();
      batch.setData(ordersDocWorkflowRef, {
        "workflow_status": order.workflowStatus,
        "admin_name": admin.name,
        "admin_id": admin.id,
        "admin_role": admin.role,
        "cancel_reason": cancelReason,
        "change_request_details" : changeRequestDetails,
        "date_created": DateTime.now().toUtc().millisecondsSinceEpoch,
      });

      if (order.workflowStatus == WorkflowStatus.canceled){
        QuerySnapshot dateLogQuesryForSelectedTimestamp = 
          await dateLogCollectionReference.where(
            "timestamp", isEqualTo: order.visiteDateTimestamp
          ).getDocuments();

        if (dateLogQuesryForSelectedTimestamp.documents.isNotEmpty) {
          final DocumentReference dateAvailabilityDoc = 
            dateLogCollectionReference.document(
              "${order.visiteDateTimestamp}"
            );
          order.orderService.forEach((s){
            batch.updateData(
              dateAvailabilityDoc, 
              <String, dynamic>{
                s.serviceCategoryId: FieldValue.arrayRemove(
                  [order.documentID]
                )
              }
            );
          });
        }
      }

      return batch.commit();
  }

  Future<void> updateServices(OrderInfo order, String docId){
    Map<String, dynamic> updatedOrderMap = Map();
    List<Map<String, dynamic>> servicesMap = List();

    order.orderService.forEach((s) {
      Map<String, dynamic> serv = Map();
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
    });
    
    updatedOrderMap = {
      "order_services": servicesMap, 
      "order_date_updated": DateTime.now().toUtc().millisecondsSinceEpoch,
      "total_discount_amount": order.totalDiscountAmount,
      "total_order_price": order.totalPriceBeforeDiscount,
      "total_order_price_after_discount": order.totalPriceAfterDiscount,
      "VAT_total": order.vatTotal,
      "total_price_with_VAT": order.totalPriceWithVAT,
    };

    CollectionReference collectionReference = isTestMode ? ordersTestCollectoion : ordersCollection;
    return collectionReference.document(docId).updateData(updatedOrderMap);
  }

  Future<void> updateOrderAdminDiscount(OrderInfo order, AdminUserInfo admin) {
    CollectionReference collectionReference = isTestMode 
      ? ordersTestCollectoion 
      : ordersCollection;
    DocumentReference ordersDocRef = collectionReference.document(order.documentID);
    return ordersDocRef.updateData({
      "admin_discount": order.adminDiscount,
      "discount_made_by_name": admin.name,
      "discount_made_by_role": admin.role,
      "discount_made_by_id": admin.id,
      "total_order_price_after_discount": order.totalPriceAfterDiscount,
      "VAT_total": order.vatTotal,
      "total_price_with_VAT": order.totalPriceWithVAT,
      'old_total_price_before_admin_discount': order.oldTotalPriceBeforeAdminDiscount
    });
  }

  Future<void> updateTimeDate(OrderInfo order, String docId){
    Map<String, dynamic> updatedOrderMap = Map();
    updatedOrderMap = {
      "visit_date": order.visitDate.millisecondsSinceEpoch,
      "visit_time": order.visitTime,
      "visit_date_and_time": order.visitDateAndTime.millisecondsSinceEpoch
    };

    CollectionReference collectionReference = isTestMode ? ordersTestCollectoion : ordersCollection;
    return collectionReference.document(docId).updateData(updatedOrderMap);
  }

  Future<QuerySnapshot> getServices(){
    CollectionReference collectionReference = isTestMode ? servicesTestCollectoion : servicesCollection;
    return collectionReference.orderBy("Order").getDocuments();
  }

  Future<DocumentSnapshot> getAdminInfo(String adminID){
    return adminUserCollection.document(adminID).get();
  }

  Future<void> updateFcmToken(String adminID, String token){
    return adminUserCollection.document(adminID).updateData({"fcm_token": token});
  }

  Stream<QuerySnapshot> getAllUsers(){
    return adminUserCollection.snapshots();
  }

  Future<void> saveOffer(OfferInfo offer) {
    Map<String, dynamic> offerMap = OfferInfo().toMapOnCreate(offer);
    return offerCollection.document().setData(offerMap);
  }

  Future<void> updateAllOffer(OfferInfo offer) {
    Map<String, dynamic> offerMap = OfferInfo().toMapOnUpdateAll(offer);
    return offerCollection.document(offer.offerID).updateData(offerMap);
  }

  Future<void> updateOfferStatus(OfferInfo offer) {
    Map<String, dynamic> offerMap = OfferInfo().toMapOnUpdateStatus(offer);
    return offerCollection.document(offer.offerID).updateData(offerMap);
  }

  Stream<QuerySnapshot> getAllOffers(){
    return offerCollection.orderBy("date_update", descending: true).snapshots();
  }

  Future<void> saveOrderOffer(OrderOfferInfo offer){
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnCreate(offer);

    CollectionReference collectionReference = isTestMode ? offersListTestCollectoion : orderOfferCollection;
    return collectionReference.document().setData(offerMap);
  }

  Future<void> updateAllOrderOffer(OrderOfferInfo offer) {
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnUpdateAll(offer);
    CollectionReference collectionReference = isTestMode ? offersListTestCollectoion : orderOfferCollection;
    return collectionReference.document(offer.id).updateData(offerMap);
  }

  Future<void> updateOrderOfferStatus(OrderOfferInfo offer) {
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnUpdateStatus(offer);

    CollectionReference collectionReference = isTestMode ? offersListTestCollectoion : orderOfferCollection;
    return collectionReference.document(offer.id).updateData(offerMap);
  }

  Stream<QuerySnapshot> getAllOrderOffers(){
    CollectionReference collectionReference = isTestMode ? offersListTestCollectoion : orderOfferCollection;
    return collectionReference
      .where("status", whereIn: [OfferStatus.active, OfferStatus.deactive])
      .orderBy("date_update", descending: true)
      .snapshots();
  }

  Future<void> saveDiscountCode(DiscountInfo discountInfo){
    Map<String, dynamic> discountInfoMap = DiscountInfo().toMapOnCreate(discountInfo);

    CollectionReference collectionReference = isTestMode ? discountTestCollection : discountCollection;
    return collectionReference.document().setData(discountInfoMap);
  }

  Stream<QuerySnapshot> getAllDiscountCode(){
    CollectionReference collectionReference = isTestMode ? discountTestCollection : discountCollection;
    return collectionReference.snapshots();
  }

  Future<void> updateDiscountCode(DiscountInfo discount){
    Map<String, dynamic> discountMap = DiscountInfo().toMapOnUpdateStatus(discount);

    CollectionReference collectionReference = isTestMode ? discountTestCollection : discountCollection;
    return collectionReference.document(discount.id).updateData(discountMap);
  }  

  Stream<QuerySnapshot> getGeneralDetails() {
    CollectionReference collectionReference = isTestMode ? generalDetailsTestCollection : generalDetailsCollection;
    return collectionReference.snapshots();
  }

  Future<SubmitOrder> getSubmittedOrderGeneralDetails() async {
    CollectionReference collectionReference = isTestMode ? generalDetailsTestCollection : generalDetailsCollection;
    DocumentSnapshot doc = await collectionReference.document("SubmitOrder").get();
    return SubmitOrder.fromDocumentSnapshot(doc);
  }

  Future<void> updateAboutUsGeneralDetails(AboutUs aboutUs) {
    Map<String, dynamic> dataMap = AboutUs().toMapOnUpdate(aboutUs);
    CollectionReference collectionReference = isTestMode ? generalDetailsTestCollection : generalDetailsCollection;

    return collectionReference.document("ContactUs").updateData(dataMap);    
  }

  Future<void> updateSharedGeneralDetails(Shared shared) {
    Map<String, dynamic> dataMap = Shared().toMapOnUpdate(shared);
    CollectionReference collectionReference = isTestMode ? generalDetailsTestCollection : generalDetailsCollection;

    return collectionReference.document("Shared").updateData(dataMap);
  }

  Future<void> updateSubmitOrderGeneralDetails(SubmitOrder submitOrder) {
    Map<String, dynamic> dataMap = SubmitOrder().toMapOnUpdate(submitOrder);
    CollectionReference collectionReference = isTestMode ? generalDetailsTestCollection : generalDetailsCollection;

    return collectionReference.document("SubmitOrder").updateData(dataMap);
  }

  Future<void> updateOrderLimitGeneralDetails(OrderLimit orderLimit) {
    Map<String, dynamic> dataMap = OrderLimit().toMapOnUpdate(orderLimit);
    CollectionReference collectionReference = isTestMode ? generalDetailsTestCollection : generalDetailsCollection;

    return collectionReference.document("orderLimit").updateData(dataMap);
  }
}