import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/discount_model.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/offer_status.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';

class DataBase{
  final adminUserCollection = Firestore.instance.collection("AdminUser");
  final ordersCollection = Firestore.instance.collection("OrdersList");
  final servicesCollection = Firestore.instance.collection("ServiceList");
  final offerCollection = Firestore.instance.collection("Offers");
  final orderOfferCollection = Firestore.instance.collection("OrderOffers");
  final dateAvailabilityCollection = Firestore.instance.collection("DateAvailabilityLog");
  final discountCollection = Firestore.instance.collection("Discount");

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

  Stream<QuerySnapshot> getPendingOrders(){
    final orders = ordersCollection
      .where("workflow_status", whereIn: [WorkflowStatus.pending, WorkflowStatus.requestChange])
      .orderBy("order_date_updated")
      .snapshots(includeMetadataChanges: true);
    return orders;
  }

  Stream<QuerySnapshot> getInProcessOrders(){
    final orders = ordersCollection
      .where("workflow_status", whereIn: [WorkflowStatus.inProcess, WorkflowStatus.requestChangeReply])
      .orderBy("order_date_updated")
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getDoneOrders(){
    final orders = ordersCollection
      .where("workflow_status", isEqualTo: WorkflowStatus.done)
      .orderBy("order_date_updated")
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getCanceledOrders(){
    final orders = ordersCollection
      .where("workflow_status", isEqualTo: WorkflowStatus.canceled)
      .orderBy("order_date_updated")
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getOrders(){
    final orders = ordersCollection
      .orderBy("order_date_updated", descending: true)
      .snapshots();
    return orders;
  }

  Future<void> updateOrderStatus(
    OrderInfo order, 
    AdminUserInfo admin,
    {String cancelReason,
    String changeRequestDetails}){

      WriteBatch batch = Firestore.instance.batch();

      DocumentReference ordersDocRef = ordersCollection.document(order.documentID);
      batch.updateData(ordersDocRef, {
        "order_status": order.orderStatus,
        "workflow_status": order.workflowStatus,
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
        final DocumentReference dateAvailabilityDoc = dateAvailabilityCollection.document("${order.visiteDateTimestamp}");
        order.orderService.forEach((s){
          batch.updateData(
            dateAvailabilityDoc, 
            <String, dynamic>{s.serviceCategoryId: FieldValue.arrayRemove([order.documentID])});
        });
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

    return ordersCollection.document(docId).updateData(updatedOrderMap);
  }

  Future<void> updateTimeDate(OrderInfo order, String docId){
    Map<String, dynamic> updatedOrderMap = Map();
    updatedOrderMap = {
      "visit_date": order.visitDate.millisecondsSinceEpoch,
      "visit_time": order.visitTime,
      "visit_date_and_time": order.visitDateAndTime.millisecondsSinceEpoch
    };
    return ordersCollection.document(docId).updateData(updatedOrderMap);
  }

  Future<QuerySnapshot> getServices(){
    return servicesCollection.orderBy("Order").getDocuments();
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
    return offerCollection.snapshots();
  }

  Future<void> saveOrderOffer(OrderOfferInfo offer){
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnCreate(offer);
    return orderOfferCollection.document().setData(offerMap);
  }

  Future<void> updateAllOrderOffer(OrderOfferInfo offer) {
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnUpdateAll(offer);
    return orderOfferCollection.document(offer.id).updateData(offerMap);
  }

  Future<void> updateOrderOfferStatus(OrderOfferInfo offer) {
    Map<String, dynamic> offerMap = OrderOfferInfo().toMapOnUpdateStatus(offer);
    return orderOfferCollection.document(offer.id).updateData(offerMap);
  }

  Stream<QuerySnapshot> getAllOrderOffers(){
    return orderOfferCollection.where("status", whereIn: [OfferStatus.active, OfferStatus.deactive]).snapshots();
  }

  Future<void> saveDiscountCode(DiscountInfo discountInfo){
    Map<String, dynamic> discountInfoMap = DiscountInfo().toMapOnCreate(discountInfo);
    return discountCollection.document().setData(discountInfoMap);
  }

  Stream<QuerySnapshot> getAllDiscountCode(){
    return discountCollection.snapshots();
  }

  Future<void> updateDiscountCode(DiscountInfo discount){
    Map<String, dynamic> discountMap = DiscountInfo().toMapOnUpdateStatus(discount);
    return discountCollection.document(discount.id).updateData(discountMap);
  }  
}