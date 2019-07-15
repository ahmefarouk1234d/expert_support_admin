import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/FirebaseResources/storage_servcice.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'db_service.dart';

class FirebaseManager{
  final _auth = Auth();
  final _db = DataBase();
  final _storage = Storage();

  // -------------------- Auth Services -------------------
  
  Future<FirebaseUser> signIn({@required String email, @required String password}){
    return _auth.signIn(email, password);
  }

  Future<void> signOut(){
    return _auth.signOut();
  }

  // -------------------- End Auth Services -------------------

  // -------------------- Database Services -------------------

  Future<void> saveAdminUser(AdminUserInfo admin){
    return _db.saveAdminUser(admin);
  }

  Stream<QuerySnapshot> getOrders(){
    return _db.getOrders();
  }

  Future<void> updateOrderStatus(String id, String status){
    return _db.updateOrderStatus(id, status);
  }

  Future<void> updateServices(List<OrderService> services, String docId){
    return _db.updateServices(services, docId);
  }

  // -------------------- End Database Services -------------------

  // -------------------- Storage Services -------------------

  

  // -------------------- End Storage Services -------------------
}