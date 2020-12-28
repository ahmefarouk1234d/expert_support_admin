import 'package:expert_support_admin/Models/order_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class OrderBloc{
  final _services = BehaviorSubject<List<OrderService>>();
  final _order = BehaviorSubject<OrderInfo>();

  Stream<List<OrderService>> get services => _services.stream;
  Sink<List<OrderService>> get servicesChange => _services.sink;

  Stream<OrderInfo> get order => _order.stream;
  Sink<OrderInfo> get ordersChange => _order.sink;

  dispose() async{
    await _services.drain();
    _services.close();
    await _order.drain();
    _order.close();
  }
}