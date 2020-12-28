import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc{
  final _admin = BehaviorSubject<AdminUserInfo>();
  final _fromDate = BehaviorSubject<DateTime>();
  final _toDate = BehaviorSubject<DateTime>();
  FirebaseManager _firebaseManager = FirebaseManager();
  
  Stream<AdminUserInfo> get admin => _admin.stream;
  Sink<AdminUserInfo> get adminChange => _admin.sink;

  Stream<DateTime> get fromDate => _fromDate.stream;
  Sink<DateTime> get fromDateChange => _fromDate.sink;

  Stream<DateTime> get toDate => _toDate.stream;
  Sink<DateTime> get toDateChange => _toDate.sink;

  Stream<QuerySnapshot> get pendingOrderDocument { 
    return _firebaseManager.getPendingOrders(_getFromDateTimeStamp(), _getToDateTimeStamp()); 
  }
  Stream<QuerySnapshot> get inProcessOrderDocument { 
    return _firebaseManager.getInProcessOrders(_getFromDateTimeStamp(), _getToDateTimeStamp()); 
  }
  Stream<QuerySnapshot> get doneOrderDocument { 
    return _firebaseManager.getDoneOrders(_getFromDateTimeStamp(), _getToDateTimeStamp()); 
  }
  Stream<QuerySnapshot> get canceledOrderDocument { 
    return _firebaseManager.getCanceledOrders(_getFromDateTimeStamp(), _getToDateTimeStamp());
  }
  Stream<QuerySnapshot> get orderDocument { 
    return _firebaseManager.getOrders(_getFromDateTimeStamp(), _getToDateTimeStamp());
  }

  Stream<QuerySnapshot> get adminListDocument => _firebaseManager.getAllUsers();
  Stream<QuerySnapshot> get offerListDocument => _firebaseManager.getAllOffers();
  Stream<QuerySnapshot> get orderOfferListDocument => _firebaseManager.getAllOrderOffers();
  Stream<QuerySnapshot> get discountListDocument => _firebaseManager.getAllDiscountCode();
  Stream<QuerySnapshot> get generalDetailsListDocument => _firebaseManager.getGeneralDetails();


  int _getFromDateTimeStamp(){
    DateTime selectedFromDate = _fromDate != null ? _fromDate.value : null;

    if (selectedFromDate == null) return null;
    return DateConvert().getTimestamp(date: selectedFromDate);
  }

  int _getToDateTimeStamp() {
    DateTime selectedToDate = _toDate != null ? _toDate.value : null;

    if (selectedToDate == null) return null;
    return DateConvert().getTimestamp(date: selectedToDate);
  }

  dispose() {
    _admin.close();
    _fromDate.close();
    _toDate.close();
  }
}