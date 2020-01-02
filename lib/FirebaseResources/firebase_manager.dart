import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'db_service.dart';

class FirebaseManager{
  final _auth = Auth();
  final _db = DataBase();

  // -------------------- Auth Services -------------------

  Future<FirebaseUser> getUser() async{
    return _auth.getUser();
  }
  
  Future<void> signIn({@required String email, @required String password, @required Function(AuthResult) onSuccess, @required Function(String) onError}){
    return _auth.signIn(email, password, onSuccess, onError);
  }

  Future<void> signUp({@required String email, @required String password, @required Function(AuthResult) onSuccess, @required Function(String) onError}){
    return _auth.signUp(email, password, onSuccess, onError);
  }

  Future<void> signOut(){
    return _auth.signOut();
  }

  Future<void> changePassword(String newPassword, Function() onSuccess, Function(String) onError){
    return _auth.changePassword(newPassword, onSuccess, onError);
  }

  Future<void> resetPassword(String email, Function() onSuccess, Function(String) onError) async{
    return _auth.resetPassword(email, onSuccess, onError);
  }

  Future<void> resendVerificationEmail(FirebaseUser user, Function() onSuccess, Function(String) onError) async{
    return _auth.resendVerificationEmail(user, onSuccess, onError);
  }

  // -------------------- End Auth Services -------------------

  // -------------------- Database Services -------------------

  Future<void> saveAdminUser(AdminUserInfo admin){
    return _db.saveAdminUser(admin);
  }

  Future<void> updateAdminUser(AdminUserInfo admin){
    return _db.updateAdminUser(admin);
  }

  Future<void> deleteAdminUser(AdminUserInfo admin){
    return _db.deleteAdminUser(admin);
  }

  Stream<QuerySnapshot> getPendingOrders(){
    return _db.getPendingOrders();
  }

  Stream<QuerySnapshot> getInProcessOrders(){
    return _db.getInProcessOrders();
  }

  Stream<QuerySnapshot> getDoneOrders(){
    return _db.getDoneOrders();
  }

  Stream<QuerySnapshot> getCanceledOrders(){
    return _db.getCanceledOrders();
  }

  Stream<QuerySnapshot> getOrders(){
    return _db.getOrders();
  }

  Future<void> updateOrderStatus(OrderInfo order, AdminUserInfo admin, {String cancelReason,
    String changeRequestDetails}){
    return _db.updateOrderStatus(order, admin, cancelReason: cancelReason, changeRequestDetails: changeRequestDetails);
  }

  Future<void> updateServices(OrderInfo order, String docId){
    return _db.updateServices(order, docId);
  }

  Future<void> updateTimeDate(OrderInfo order, String docId){
    return _db.updateTimeDate(order, docId);
  }

  Future<QuerySnapshot> getServices(){
    return _db.getServices();
  }

  Future<DocumentSnapshot> getAdminInfo(String adminID){
    return _db.getAdminInfo(adminID);
  }

  Future<void> updateFcmToken(String adminID, String token){
    return _db.updateFcmToken(adminID, token);
  }

  Stream<QuerySnapshot> getAllUsers(){
    return _db.getAllUsers();
  }

  Future<void> saveOffer(OfferInfo offer) {
    return _db.saveOffer(offer);
  }

  Future<void> updateAllOffer(OfferInfo offer) {
    return _db.updateAllOffer(offer);
  }

  Future<void> updateOfferStatus(OfferInfo offer) {
    return _db.updateOfferStatus(offer);
  }

  Stream<QuerySnapshot> getAllOffers(){
    return _db.getAllOffers();
  }

  Future<void> saveOrderOffer(OrderOfferInfo offer){
    return _db.saveOrderOffer(offer);
  }

  Future<void> updateAllOrderOffer(OrderOfferInfo offer) {
    return _db.updateAllOrderOffer(offer);
  }

  Future<void> updateOrderOfferStatus(OrderOfferInfo offer) {
    return _db.updateOrderOfferStatus(offer);
  }

  Stream<QuerySnapshot> getAllOrderOffers(){
    return _db.getAllOrderOffers();
  }

  // -------------------- End Database Services -------------------

  // -------------------- Storage Services -------------------

  

  // -------------------- End Storage Services -------------------
}