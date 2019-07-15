import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';

class DataBase{
  final Firestore _db = Firestore.instance;
  final adminUserCollection = Firestore.instance.collection("AdminUser");
  final ordersCollection = Firestore.instance.collection("OrdersList");

  Future<void> saveAdminUser(AdminUserInfo admin) {
    return adminUserCollection.document(admin.id).setData({
      "email": admin.email,
      "role": admin.role,
      "fcmToken": admin.fcmToken,
    });
  }

  Stream<QuerySnapshot> getOrders(){
    final orders = ordersCollection.orderBy("OrderDateCreated", descending: true).snapshots();
    return orders;
  }

  Future<void> updateOrderStatus(String id, String status){
    return ordersCollection.document(id).updateData({"OrderStatus": status});
  }

  Future<void> updateServices(List<OrderService> services, String docId){
    Map<String, dynamic> updatedOrderMap = Map();
    List<Map<String, dynamic>> servicesMap = List();

    services.forEach((s) {
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
      "OrderDateUpdated": DateTime.now().toUtc().millisecondsSinceEpoch
    };

    return ordersCollection.document(docId).updateData(updatedOrderMap);
  }
}