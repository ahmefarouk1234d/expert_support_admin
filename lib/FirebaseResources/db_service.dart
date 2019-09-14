import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
class DataBase{
  final adminUserCollection = Firestore.instance.collection("AdminUser");
  final ordersCollection = Firestore.instance.collection("OrdersList");
  final servicesCollection = Firestore.instance.collection("Services");
  final offerCollection = Firestore.instance.collection("Offers");

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
      .where("OrderStatus", isEqualTo: OrderStatus.pending)
      .snapshots(includeMetadataChanges: true);
    return orders;
  }

  Stream<QuerySnapshot> getRequestChangeOrders(){
    final orders = ordersCollection
      .where("OrderStatus", isEqualTo: OrderStatus.requestChange)
      .snapshots(includeMetadataChanges: true);
    return orders;
  }

  Stream<QuerySnapshot> getInProcessOrders(){
    final orders = ordersCollection
      .where("OrderStatus", isEqualTo: OrderStatus.inProcess)
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getDoneOrders(){
    final orders = ordersCollection
      .where("OrderStatus", isEqualTo: OrderStatus.done)
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getCanceledOrders(){
    final orders = ordersCollection
      .where("OrderStatus", isEqualTo: OrderStatus.canceled)
      .snapshots();
    return orders;
  }

  Stream<QuerySnapshot> getOrders(){
    final orders = ordersCollection.orderBy("OrderDateCreated", descending: true).snapshots();
    return orders;
  }

  Future<void> updateOrderStatus(
    String id, 
    String status, 
    AdminUserInfo admin,
    {String cancelReason,
    String changeRequestDetails}){
    return ordersCollection.document(id).updateData({
      "OrderStatus": status,
      "adminName": admin.name,
      "adminID": admin.id,
      "adminRole": admin.role,
      "cancelReason": cancelReason,
      "changeRequestDetails" : changeRequestDetails,
    });
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
      "VisitTime": order.visitTime
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

  Future<void> updateOfferStaus(OfferInfo offer) {
    Map<String, dynamic> offerMap = OfferInfo().toMapOnUpdateStatus(offer);
    return offerCollection.document(offer.offerID).updateData(offerMap);
  }
}