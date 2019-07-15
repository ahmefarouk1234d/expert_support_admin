import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc{
  final _admin = BehaviorSubject<AdminUserInfo>();
  FirebaseManager _firebaseManager = FirebaseManager();

  Stream<AdminUserInfo> get admin => _admin.stream;
  Sink<AdminUserInfo> get adminChange => _admin.sink;

  Stream<QuerySnapshot> get orderDocument => _firebaseManager.getOrders();

  dispose() {
    _admin.close();
  }
}