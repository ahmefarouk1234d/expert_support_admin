import 'dart:async';
import 'package:async/async.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc{
  final _admin = BehaviorSubject<AdminUserInfo>();
  FirebaseManager _firebaseManager = FirebaseManager();
  
  Stream<AdminUserInfo> get admin => _admin.stream;
  Sink<AdminUserInfo> get adminChange => _admin.sink;

  Stream<QuerySnapshot> get pendingOrderDocument => _firebaseManager.getPendingOrders();
  Stream<QuerySnapshot> get inProcessOrderDocument => _firebaseManager.getInProcessOrders();
  Stream<QuerySnapshot> get doneOrderDocument => _firebaseManager.getDoneOrders();
  Stream<QuerySnapshot> get canceledOrderDocument => _firebaseManager.getCanceledOrders();
  Stream<QuerySnapshot> get orderDocument => _firebaseManager.getOrders();
  Stream<QuerySnapshot> get adminListDocument => _firebaseManager.getAllUsers();
  Stream<QuerySnapshot> get offerListDocument => _firebaseManager.getAllOffers();
  Stream<QuerySnapshot> get orderOfferListDocument => _firebaseManager.getAllOrderOffers();

  dispose() {
    _admin.close();
  }
}