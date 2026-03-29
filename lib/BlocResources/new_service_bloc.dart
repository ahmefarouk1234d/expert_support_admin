import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';

class NewServiceBloc{
  final FirebaseManager _firebaseManager = FirebaseManager();

  Future<QuerySnapshot> get serviceDocument => _firebaseManager.getServices();
}