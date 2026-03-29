import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/Home/Order/details/details_content.dart';
import 'package:expert_support_admin/SharedWidget/app_bar_action_button.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

class OrderDetails extends StatefulWidget {
  static String route = "/OrderDetails";
  final int? index;
  final OrderInfo? order;
  final OrderToDisplay? orderToDisplay;
  const OrderDetails({super.key, this.order, this.index, this.orderToDisplay});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late AppBloc _appBloc;
  late AppLocalizations _localizations;
  late OrderInfo _order;
  late bool _hasAdminDiscount;
  final FirebaseManager _firebaseManager = FirebaseManager();

  @override
  void initState() {
    _order = widget.order!;
    _hasAdminDiscount = _order.adminDiscount != null;
    super.initState();
  }

  void _onAppBarActionButtonTapped(AdminUserInfo admin) {
    if (_hasAdminDiscount) {
      _onDeleteDiscount(admin);
    } else {
      _onAddDiscount(admin); 
    }
  }

  void _onAddDiscount(AdminUserInfo admin) {
    showDialog(
      context: context,
      builder: (_) {
        return AddDiscountDialog(
          onSave: (discount) { 
            Alert().conformation(context,
              _localizations.translate(LocalizedKey.conformationAlertTitle), 
              _localizations.translate(LocalizedKey.addAdminDiscountAlertMessage),
              () { _updateTotalPrice(admin: admin, discount: discount); }
            );
          },
        );
      },
    );
  }
  
  void _onDeleteDiscount(AdminUserInfo admin) {
    Alert().conformation(
      context, 
      _localizations.translate(LocalizedKey.conformationAlertTitle), 
      _localizations.translate(LocalizedKey.removeAdminDiscountAlertMessage), 
      () { _updateTotalPrice(admin: admin); });
  }

  void _updateTotalPrice({AdminUserInfo? admin, num? discount}) async {
    Common().loading(context);

    _changeOrderTotalPrice(discount: discount);
    await _firebaseManager.updateOrderAdminDiscount(_order, admin!);

    setState(() {
      _hasAdminDiscount = discount != null;
    });

    Common().dismiss(context);
  }

  void _changeOrderTotalPrice({num? discount}) {
    bool isDelete = discount == null;
    double vatPercentage = _order.vatPercentage != null 
      ? (_order.vatPercentage! / 100) 
      : 0.05;
    num totalPrice = _getTotalPrice(isDelete);

    _order.adminDiscount = discount;
    //_order.totalPriceAfterDiscount = isDelete ? (totalPrice) : (totalPrice - discount);
    _order.vatTotal = _order.totalPriceAfterDiscount! * vatPercentage;
    _order.totalPriceWithVAT = (isDelete ? (totalPrice) : (totalPrice - discount)) + _order.vatTotal!;
    _order.oldTotalPriceBeforeAdminDiscount = isDelete ? null : totalPrice;
  }

  num _getTotalPrice(bool isOnDeleting) {
    if (isOnDeleting) {
      return _order.oldTotalPriceBeforeAdminDiscount!;
    } else {
      return _order.totalPriceAfterDiscount != 0.0
        ? _order.totalPriceAfterDiscount!
        : _order.totalPriceBeforeDiscount!;
    }
  }

  bool get _isInProcess {
    return _order.workflowStatus == WorkflowStatus.inProcess
      || (_order.workflowStatus == WorkflowStatus.requestChangeReply
        && _order.orderStatus == WorkflowStatus.inProcess);
  }

  bool get _isOnTheWay {
    return _order.workflowStatus == WorkflowStatus.onTheWay
      || (_order.workflowStatus == WorkflowStatus.requestChangeReply
        && _order.orderStatus == WorkflowStatus.onTheWay);
  }

  bool get _isArrived {
    return _order.workflowStatus == WorkflowStatus.arrived
      || (_order.workflowStatus == WorkflowStatus.requestChangeReply
        && _order.orderStatus == WorkflowStatus.arrived);
  }

  bool _isSupervior(AsyncSnapshot<AdminUserInfo> snapshot) {
    return snapshot.hasData && snapshot.data!.role == AdminRole.supervisor;
  }

  bool get _canAddDiscount {
    return _isInProcess || _isOnTheWay || _isArrived;
  }

  String get _actionButtonTitle {
    return _hasAdminDiscount
      ? _localizations.translate(LocalizedKey.removeDiscountButtonTitle)
      : _localizations.translate(LocalizedKey.addDiscountButtonTitle);
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of(context);
    _localizations = AppLocalizations.of(context);

    return StreamBuilder<AdminUserInfo>(
        stream: _appBloc.admin,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_order.id!),
              elevation: 0.0,
              actions: <Widget>[
                _isSupervior(snapshot) && _canAddDiscount
                  ? AppBarActionButton(
                      title: _actionButtonTitle,
                      onPressed: () { _onAppBarActionButtonTapped(snapshot.data!); },
                    )
                  : Container()
              ],
            ),
            body: BlocProvider<OrderBloc>(
              builder: (context, orderBloc) => orderBloc ?? OrderBloc(),
              onDispose: (context, orderBloc) => orderBloc?.dispose(),
              child: Container(
                child: OrderDetailsContent(
                  order: _order,
                  orderToDisplay: widget.orderToDisplay,
                ),
              ),
            ),
          );
        });
  }
}

class AddDiscountDialog extends StatelessWidget {
  AddDiscountDialog({super.key, this.onSave});

  final Function(num)? onSave;

  final TextEditingController dicountAmountControl = TextEditingController();

  void _onSave(BuildContext context) {
    String discountString = dicountAmountControl.text;
    if (discountString.isNotEmpty && Common().canCastToNum(discountString)) {
      num discount = double.parse(discountString);
      Common().dismiss(context);
      onSave?.call(discount);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: dicountAmountControl,
              keyboardType: TextInputType.number,
              inputFormatters: Common().getNumberOnlyInputFormatters(),
              decoration: InputDecoration(hintText: localizations.translate(LocalizedKey.discountAmountText))
            ),
            Container(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton(
                  child: Text(localizations.translate(LocalizedKey.saveButtonTitle)),
                  onPressed: () { 
                    Common().removeFocus(context);
                    _onSave(context); 
                  }
                ),
                OutlinedButton(
                  child: Text(localizations.translate(LocalizedKey.cancelButtonTitle)),
                  onPressed: () { 
                    Common().removeFocus(context);
                    Common().dismiss(context); 
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
