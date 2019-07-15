
import 'package:flutter/material.dart';
import 'order_bloc.dart';

class OrderProvider extends InheritedWidget{
  final OrderBloc orderBloc;

  OrderProvider({
    Key key,
    OrderBloc orderBloc,
    Widget child,
  }) : orderBloc = orderBloc ?? OrderBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(OrderProvider oldWidget) => oldWidget.orderBloc != orderBloc;

  static OrderBloc of(BuildContext context) => (context.inheritFromWidgetOfExactType(OrderProvider) as OrderProvider).orderBloc;
}

class OrderBlocProvider extends StatefulWidget{
  final void Function(BuildContext context, OrderBloc orderBloc) onDispose;
  final OrderBloc Function(BuildContext context, OrderBloc orderBloc) builder;
  final Widget child;

  OrderBlocProvider({
    Key key,
    @required this.child,
    @required this.builder,
    @required this.onDispose
  }) : super(key: key);
  
  _OrderBlocProviderState createState() => _OrderBlocProviderState();
}

class _OrderBlocProviderState extends State<OrderBlocProvider>{
  OrderBloc orderBloc;

  @override
  void initState() {
    if (widget.onDispose != null){
      orderBloc = widget.builder(context, orderBloc);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onDispose != null){
      widget.onDispose(context, orderBloc);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrderProvider(
      orderBloc: orderBloc,
      child: widget.child,
    );
  }
}