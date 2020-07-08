import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/offer_status.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderOffer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: OrderOfferContent(),
      ),
    );
  }
}

class OrderOfferContent extends StatefulWidget {
  @override
  _OrderOfferContentState createState() => _OrderOfferContentState();
}

class _OrderOfferContentState extends State<OrderOfferContent> {
  List<OrderOfferInfo> offerList;
  AppBloc _appBloc;

  @override
  void initState() {
    offerList = List();
    super.initState();
  }

  _navigateToOfferDetails(OrderOfferInfo offer, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OrderOfferDetails(offerInfo: offer,)
    ));
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: _appBloc.orderOfferListDocument,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          offerList =
              OrderOfferInfo.fromMapList(offerDocDataList: snapshot.data.documents);
          return offerList.isEmpty
              ? NoData()
              : OrderOfferList(
                  offerList: offerList, //.reversed.toList(),
                  onTap: _navigateToOfferDetails,
                );
        });
  }
}

class OrderOfferList extends StatelessWidget {
  final List<OrderOfferInfo> offerList;
  final Function(OrderOfferInfo offer, int index) onTap;
  OrderOfferList({this.offerList, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: offerList.length,
        separatorBuilder: (context, index) => Divider(color: Colors.black12,),
        itemBuilder: (context, index){
          final OrderOfferInfo offer = offerList[index];
          bool isActive = offer.status == OfferStatus.active;
          String offerTitle = 
            AppLocalizations.of(context).isArabic()
            ? offer.titleAr ?? ""
            : offer.titleEn ?? "";
          String dateUpdate = 
            offer.dateUpdateTimestamp == null ? "" :
            DateConvert().toStringFromTimestamp(
              timestamp: offer.dateUpdateTimestamp, 
              locale: AppLocalizations.of(context).locale.languageCode, 
              isFull: true);
          IconData icon = 
            AppLocalizations.of(context).isArabic()
            ? Icons.keyboard_arrow_left
            : Icons.keyboard_arrow_right;
          BoxBorder border =
            AppLocalizations.of(context).isArabic()
            ? Border(right: BorderSide(width: 4, color: isActive ? Colors.green : Colors.red))
            : Border(left: BorderSide(width: 4, color: isActive ? Colors.green : Colors.red));
          
          return Container(
            decoration: BoxDecoration(
              border: border,
            ),
            child: ListTile(
              onTap: () => onTap(offer, index),
              title: Text(offerTitle),
              subtitle: Text(dateUpdate),
              trailing: Icon(icon, color: Colors.black12,),
            ),
          );
        }
      ),
    );
  }
}

class OrderOfferDetails extends StatefulWidget {
  final OrderOfferInfo offerInfo;
  OrderOfferDetails({this.offerInfo});

  @override
  _OrderOfferDetailsState createState() => _OrderOfferDetailsState();
}

class _OrderOfferDetailsState extends State<OrderOfferDetails> {
  OrderOfferInfo _info;
  String _offerStatus;
  String _buttonTitle;
  FirebaseManager _firebaseManager = FirebaseManager();
  bool isInitial;
  bool isActive;
  bool isButtonsEnable;

  @override
  void initState() {
    _info = widget.offerInfo;
    _offerStatus = _info.status;
    isInitial = true;
    isActive = _info.status == OfferStatus.active;
    isButtonsEnable = _info.status != OfferStatus.deleted;
    super.initState();
  }

  _showConformatiomAlert(String status) {
    String message = 
      status != OfferStatus.deleted
      ? AppLocalizations.of(context).translate(LocalizedKey.offerStatusChangeAlertMessage)
      : AppLocalizations.of(context).translate(LocalizedKey.offerStatusDeleteAlertMessage);
      
    Alert().conformation(
        context, AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), message, 
        () => _handleChangeStatus(status));
  }

  _showCompletedAlert({String message}){
    Alert().success(context, message, () {
      Common().dismiss(context);
    });
  }

  _handleChangeStatus(String status) async{
    try{
      Common().loading(context);
      OrderOfferInfo offerInfo = OrderOfferInfo(
        id: _info.id,
        status: status
      );
      await _firebaseManager.updateOrderOfferStatus(offerInfo);
      setState(() {
        _offerStatus = status;
        if (status != OfferStatus.deleted) {
          isActive = !isActive;
        } else {
          isButtonsEnable = false;
          isActive = false;
        }
      });
      Common().dismiss(context);
      _showCompletedAlert(
        message: 
          status != OfferStatus.deleted
          ? AppLocalizations.of(context).translate(LocalizedKey.offerStatusChangeSuccessAlertMessage)
          : AppLocalizations.of(context).translate(LocalizedKey.offerStatusDeleteSuccessAlertMessage)
      );
    } on PlatformException catch(e){
      Common().dismiss(context);
      Alert().error(context, e.message, () => Common().dismiss(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    _buttonTitle = isActive
      ? AppLocalizations.of(context).translate(LocalizedKey.offerDeactiveButtonTitle) 
      : AppLocalizations.of(context).translate(LocalizedKey.offerActiveButtonTitle);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(LocalizedKey.offerAppBarTitle)),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            OrderOfferDetailsRow(
              title: AppLocalizations.of(context).translate(LocalizedKey.offerTitle), 
              value: AppLocalizations.of(context).isArabic() ? _info.titleAr : _info.titleEn,),
            OrderOfferDetailsRow(
              title: AppLocalizations.of(context).translate(LocalizedKey.offerDescTitle), 
              value: AppLocalizations.of(context).isArabic() ? _info.descAr : _info.descEn,),
            _info.offerType == OfferType.packages
            ? OrderOfferDetailsRow(
                title: AppLocalizations.of(context).translate(LocalizedKey.offerServiceDetailsTitle), 
                value: AppLocalizations.of(context).isArabic() ? _info.serviceDetailsAr : _info.serviceDetailsEn,)
            : Container(),
            _info.offerType == OfferType.services
            ? OrderOfferDetailsRow(
                title: AppLocalizations.of(context).translate(LocalizedKey.offerOriginalServicePrice), 
                value: _info.originalPrice.toString(),)
            : Container(),
            OrderOfferDetailsRow(
              title: AppLocalizations.of(context).translate(LocalizedKey.offerPriceTitle), 
              value: _info.priceForOne.toString(),),
            _info.offerType == OfferType.services
            ? OrderOfferDetailsRow(
                title: AppLocalizations.of(context).translate(LocalizedKey.offerQtyTitle), 
                value: _info.qauntity.toString(),)
            : Container(),
            OrderOfferDetailsRow(
              title: AppLocalizations.of(context).translate(LocalizedKey.offerStatusTitle), 
              value: OfferStatus().getDisplayStaus(status: _offerStatus, context: context),),
            Container(height: 16,),
            CommonButton(
              title: _buttonTitle,
              onPressed: isButtonsEnable ? () { 
                String status = isActive ? OfferStatus.deactive : OfferStatus.active;
                _showConformatiomAlert(status);
              } : null,
            ),
            Container(height: 16,),
            CommonButton(
              title: AppLocalizations.of(context).translate(LocalizedKey.offerDeleteButtonTitle),
              onPressed: isButtonsEnable ? () {
                _showConformatiomAlert(OfferStatus.deleted);
              } : null,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderOfferDetailsRow extends StatelessWidget {
  final String title;
  final String value;
  OrderOfferDetailsRow({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text(title + ":", style: TextStyle(fontWeight: FontWeight.w700),),
          Container(width: 8,),
          Expanded(child: Text(value),)
        ],
      ),
    );
  }
}