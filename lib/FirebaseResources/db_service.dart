import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:firebase_auth/firebase_auth.dart';
class DataBase{
  final adminUserCollection = Firestore.instance.collection("AdminUser");
  final ordersCollection = Firestore.instance.collection("OrdersList");
  final servicesCollection = Firestore.instance.collection("Services");
  final offerCollection = Firestore.instance.collection("Offers");
  final orderOfferCollection = Firestore.instance.collection("OrderOffers");

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
      .where("WorkflowStatus", isEqualTo: WorkflowStatus.pending)
      .snapshots(includeMetadataChanges: true);
    return orders;
  }

  Stream<QuerySnapshot> getRequestChangeOrders(){
    final orders = ordersCollection
      .where("WorkflowStatus", isEqualTo: WorkflowStatus.requestChange)
      .snapshots(includeMetadataChanges: true);
    return orders;
  }

  Stream<QuerySnapshot> getInProcessOrders(){
    final orders = ordersCollection
      .where("WorkflowStatus", isEqualTo: WorkflowStatus.inProcess)
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getRequestChangeReplyOrders(){
    final orders = ordersCollection
      .where("WorkflowStatus", isEqualTo: WorkflowStatus.requestChangeReply)
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getDoneOrders(){
    final orders = ordersCollection
      .where("WorkflowStatus", isEqualTo: WorkflowStatus.done)
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getCanceledOrders(){
    final orders = ordersCollection
      .where("WorkflowStatus", isEqualTo: WorkflowStatus.canceled)
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getOrders(){
    final orders = ordersCollection.orderBy("OrderDateCreated", descending: true).snapshots();
    return orders;
  }

  Future<void> updateOrderStatus(
    String id, 
    String orderStatus,
    String workflowStatus, 
    AdminUserInfo admin,
    {String cancelReason,
    String changeRequestDetails}){

      WriteBatch batch = Firestore.instance.batch();

      DocumentReference ordersDocRef = ordersCollection.document(id);
      batch.updateData(ordersDocRef, {
        "OrderStatus": orderStatus,
        "WorkflowStatus": workflowStatus,
        "adminName": admin.name,
        "adminID": admin.id,
        "adminRole": admin.role,
        "cancelReason": cancelReason,
        "changeRequestDetails" : changeRequestDetails,
        "OrderDateUpdated": DateTime.now().toUtc().millisecondsSinceEpoch,
      });

      DocumentReference ordersDocWorkflowRef = ordersDocRef.collection("workflow").document();
      batch.setData(ordersDocWorkflowRef, {
        "WorkflowStatus": workflowStatus,
        "adminName": admin.name,
        "adminID": admin.id,
        "adminRole": admin.role,
        "cancelReason": cancelReason,
        "changeRequestDetails" : changeRequestDetails,
        "dateCreated": DateTime.now().toUtc().millisecondsSinceEpoch,
      });

      return batch.commit();
  }

  Future<void> updateServices(OrderInfo order, String docId){
    Map<String, dynamic> updatedOrderMap = Map();
    List<Map<String, dynamic>> servicesMap = List();

    order.orderService.forEach((s) {
      Map<String, dynamic> serv = Map();
      serv = {
        "IsPartNeededAvailable": s.hasParts,
        "Quantity": s.quantity,
        "priceForOnePiece": s.priceForOnePiece,
        "serviceID": s.id,
        "serviceNameAr": s.nameAr,
        "serviceNameEn": s.nameEn,
        "totalPrice": s.total
      };
      servicesMap.add(serv);
    });
    
    updatedOrderMap = {
      "OrderServices": servicesMap, 
      "OrderDateUpdated": DateTime.now().toUtc().millisecondsSinceEpoch,
      "TotalDiscountAmount": order.totalDiscountAmount,
      "TotalOrderPrice": order.totalPriceBeforeDiscount,
      "TotalOrderPriceAfterDiscount": order.totalPriceAfterDiscount,
      "VATTotal": order.vatTotal,
      "TotalPriceWithVAT": order.totalPriceWithVAT,
    };

    return ordersCollection.document(docId).updateData(updatedOrderMap);
  }

  Future<void> updateTimeDate(OrderInfo order, String docId){
    Map<String, dynamic> updatedOrderMap = Map();
    updatedOrderMap = {
      "VisitDate": order.visitDate.millisecondsSinceEpoch,
      "VisitTime": order.visitTime,
      "VisitDateAndTime": order.visitDateAndTime.millisecondsSinceEpoch
    };
    return ordersCollection.document(docId).updateData(updatedOrderMap);
  }

  Future<QuerySnapshot> getServices(){
    return servicesCollection.getDocuments();
  }

  Future<DocumentSnapshot> getAdminInfo(String adminID){
    return adminUserCollection.document(adminID).get();
  }

  Future<void> updateFcmToken(String adminID, String token){
    return adminUserCollection.document(adminID).updateData({"fcmToken": token});
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
    return orderOfferCollection.snapshots();
  }

}