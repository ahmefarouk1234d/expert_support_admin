import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/discount_model.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
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

  Stream<QuerySnapshot> getPendingOrders(int fromDate, int toDate){
    return _db.getPendingOrders(fromDate, toDate);
  }

  Stream<QuerySnapshot> getInProcessOrders(int fromDate, int toDate){
    return _db.getInProcessOrders(fromDate, toDate);
  }

  Stream<QuerySnapshot> getDoneOrders(int fromDate, int toDate){
    return _db.getDoneOrders(fromDate, toDate);
  }

  Stream<QuerySnapshot> getCanceledOrders(int fromDate, int toDate){
    return _db.getCanceledOrders(fromDate, toDate);
  }

  Stream<QuerySnapshot> getOrders(int fromDate, int toDate){
    return _db.getOrders(fromDate, toDate);
  }

  Future<void> updateOrderStatus(
    OrderInfo order, 
    AdminUserInfo admin, 
    {String cancelReason,
    String changeRequestDetails}){
    return _db.updateOrderStatus(order, admin, cancelReason: cancelReason, changeRequestDetails: changeRequestDetails);
  }

  Future<void> updateOrderAdminDiscount(OrderInfo order, AdminUserInfo admin) {
    return _db.updateOrderAdminDiscount(order, admin);
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

  Future<void> saveDiscountCode(DiscountInfo discountInfo){
    return _db.saveDiscountCode(discountInfo);
  }

  Stream<QuerySnapshot> getAllDiscountCode() {
    return _db.getAllDiscountCode();
  }

  Future<void> updateDiscountCode(DiscountInfo discount) {
    return _db.updateDiscountCode(discount);
  }

  Stream<QuerySnapshot> getGeneralDetails() {
    return _db.getGeneralDetails();
  }

  Future<SubmitOrder> getSubmittedOrderGeneralDetails() {
    return _db.getSubmittedOrderGeneralDetails();
  }

  Future<void> updateAboutUsGeneralDetails(AboutUs aboutUs) {
    return _db.updateAboutUsGeneralDetails(aboutUs);
  }


  Future<void> updateSharedGeneralDetails(Shared shared) {
    return _db.updateSharedGeneralDetails(shared);
  }


  Future<void> updateSubmitOrderGeneralDetails(SubmitOrder submitOrder) {
    return _db.updateSubmitOrderGeneralDetails(submitOrder);
  }

  Future<void> updateOrderLimitGeneralDetails(OrderLimit orderLimit) {
    return _db.updateOrderLimitGeneralDetails(orderLimit);
  }

  // -------------------- End Database Services -------------------

  // -------------------- Storage Services -------------------

  

  // -------------------- End Storage Services -------------------
}