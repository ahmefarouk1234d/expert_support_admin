import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/offer_model.dart';
import 'package:expert_support_admin/Models/offer_status.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Offers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: OfferContent(),
    );
  }
}

class OfferContent extends StatefulWidget {
  @override
  _OfferContentState createState() => _OfferContentState();
}

class _OfferContentState extends State<OfferContent> {
  List<OfferInfo> offerList;
  AppBloc _appBloc;

  @override
  void initState() {
    offerList = List();
    super.initState();
  }

  _navigateToOfferDetails(OfferInfo offer, int index){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OfferDetails(offerInfo: offer,)
    ));
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _appBloc.offerListDocument,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } 
        offerList = OfferInfo.fromMapList(offerDocDataList: snapshot.data.documents);
        return offerList.isEmpty 
          ? NoData() 
          : OfferList(
              orderList: offerList, //.reversed.toList(), 
              onTap: _navigateToOfferDetails,
            );
      }
    );
  }
}

class OfferList extends StatelessWidget {
  final List<OfferInfo> orderList;
  final Function(OfferInfo offer, int index) onTap;
  OfferList({this.orderList, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: orderList.length,
        separatorBuilder: (context, index) => Divider(color: Colors.black12,),
        itemBuilder: (context, index) {
          final OfferInfo offer = orderList[index];
          bool isActive = offer.isActive;
          return Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(width: 4, color: isActive ? Colors.green : Colors.red)),
            ),
            child: ListTile(
              onTap: () => onTap(offer, index),
              title: Text(offer.offerTitleEn ?? ""),
              subtitle: Text(offer.dateUpdate ?? ""),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black12,),
            ),
          );
        }
      )
    );
  }
}

class OfferDetails extends StatefulWidget {
  final OfferInfo offerInfo;
  OfferDetails({this.offerInfo});

  @override
  _OfferDetailsState createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  OfferInfo _info;
  String _offerStatus;
  String _buttonTitle;
  FirebaseManager _firebaseManager = FirebaseManager();

  @override
  void initState() {
    _info = widget.offerInfo;
    _offerStatus = _info.isActive ? OfferStatus.active : OfferStatus.deactive;
    _buttonTitle = _info.isActive ? TextContent.deactiveButtonTitle : TextContent.activeButtonTitle;
    super.initState();
  }

  _showConformatiomAlert() {
    String message = "Are are sure you want to change offer status?";
    Alert().conformation(
        context, "Conformation", message, () => _handleChangeStatus());
  }

  _showCompletedAlert({String message}){
    Alert().success(context, message, () {
      Common().dismiss(context);
    });
  }

  _handleChangeStatus() async{
    bool isActive = _buttonTitle == TextContent.activeButtonTitle;
    try{
      Common().loading(context);
      OfferInfo offerInfo = OfferInfo(
        offerID: _info.offerID,
        isActive: isActive
      );
      await _firebaseManager.updateOfferStatus(offerInfo);
      setState(() {
        _offerStatus = isActive ? OfferStatus.active : OfferStatus.deactive;
        _buttonTitle = isActive ? TextContent.deactiveButtonTitle : TextContent.activeButtonTitle;
      });
      Common().dismiss(context);
      _showCompletedAlert(message: "Offer has been updated successfully");
    } on PlatformException catch(e){
      Common().dismiss(context);
      Alert().error(context, e.message, () => Common().dismiss(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offer Details"),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            OfferDetailsRow(title: "Title", value: _info.offerTitleEn,),
            OfferDetailsRow(title: "Description", value: _info.offerDescEn,),
            OfferDetailsRow(title: "Price", value: _info.price,),
            OfferDetailsRow(title: "Quantity", value: _info.qauntity,),
            OfferDetailsRow(title: "Status", value: OfferStatus().getDisplayStaus(status: _offerStatus),),
            Container(height: 16,),
            CommonButton(
              title: _buttonTitle,
              onPressed: _showConformatiomAlert,
            ),
          ],
        ),
      ),
    );
  }
}

class OfferDetailsRow extends StatelessWidget {
  final String title;
  final String value;
  OfferDetailsRow({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text(title + ":"),
          Container(width: 8,),
          Expanded(child: Text(value),)
        ],
      ),
    );
  }
}