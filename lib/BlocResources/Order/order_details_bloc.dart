import 'package:expert_support_admin/Models/order_model.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailsBloc{
  final _orderController = BehaviorSubject<OrderInfo>();
  final _statusController = BehaviorSubject<bool>();

  Stream<OrderInfo> get order => _orderController.stream;
  Sink<OrderInfo> get orderChange => _orderController.sink;

  Stream<bool> get status => _statusController.stream;
  Sink<bool> get statusChange => _statusController.sink;


  void dispose(){
    _orderController.close();
    _statusController.close();
  }
}