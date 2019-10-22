import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/day_time_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderMainInfo extends StatelessWidget {
  final OrderInfo order;
  OrderMainInfo(this.order);

  @override
  Widget build(BuildContext context) {
    String phone = order.userPhone.replaceAll("+966", '0');
    String localCode = AppLocalizations.of(context).locale.languageCode;
    String visitDate = DateConvert().toStringFromDate(date: order.visitDate, locale: localCode);
    AppLocalizations localizations = AppLocalizations.of(context);
    String orderStatus = OrderStatus().getDisplayStatus(status: order.status, context: context);
    String visitTime = 
      order.visitDateAndTime != null
      ? TimeOfDay(
        hour: order.visitDateAndTime.hour, 
        minute: order.visitDateAndTime.minute).format(context)
      : DayTime().getDisplayStatus(dayTime: order.visitTime, context: context);

    return Container(
          child: Column(
            children: <Widget>[
              OrderInfoRow(
                title: localizations.translate(LocalizedKey.customerNameTitle), 
                value: "${order.username}",),
              OrderInfoPhoneRow(
                title: localizations.translate(LocalizedKey.customerPhoneTitle), 
                value: phone,),
              OrderInfoRow(
                title: localizations.translate(LocalizedKey.statusTitle), 
                value: orderStatus,),
              OrderInfoRow(
                title: localizations.translate(LocalizedKey.dateTitle), 
                value: "$visitDate",),
              OrderInfoRow(
                title: localizations.translate(LocalizedKey.timeTitle), 
                value: visitTime,),
              OrderInfoMapRow(
                title: localizations.translate(LocalizedKey.locationTitle), 
                latitude: order.coordinate.latitude, 
                logntitude: order.coordinate.logntitude,),
              OrderInfoRow(
                title: localizations.translate(LocalizedKey.otherDetailsTitle), 
                value: "${order.comment}",),
            ],
          ),
        );
  }
}

class OrderInfoRow extends StatelessWidget {
  final String title;
  final String value;
  OrderInfoRow({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
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

class OrderInfoPhoneRow extends StatelessWidget {
  final String title;
  final String value;
  OrderInfoPhoneRow({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
            children: <Widget>[
              Text(title + ":", style: TextStyle(fontWeight: FontWeight.w700),),
              Container(width: 8,),
              Expanded(child: PhoneLauncher(phone: value,))
            ],
          ),
    );
  }
}

class OrderInfoMapRow extends StatelessWidget {
  final String title;
  final num latitude;
  final num logntitude;
  OrderInfoMapRow({@required this.title, @required this.latitude, @required this.logntitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
            children: <Widget>[
              Text(title, style: TextStyle(fontWeight: FontWeight.w700),),
              Container(width: 8,),
              Expanded(child: MapLauncher(latitude: latitude, logntitude: logntitude,))
            ],
          ),
    );
  }
}

class PhoneLauncher extends StatelessWidget {
  final String phone;
  PhoneLauncher({@required this.phone});

  launchUrl() async{
    String url = "tel://$phone";
    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: launchUrl,
      child: Text(phone, style: TextStyle(color: Colors.blue)),
    );
  }
}

class MapLauncher extends StatelessWidget {
  final num latitude;
  final num logntitude;
  MapLauncher({@required this.latitude, @required this.logntitude});

  launchUrl() async{
    String url = "https://www.google.com/maps/search/?api=1&query=$latitude,$logntitude";
    //String url = "comgooglemaps://?saddr=$latitude,$logntitude";
    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: launchUrl,
      child: Text(
        AppLocalizations.of(context).translate(LocalizedKey.openMapsText), 
        style: TextStyle(color: Colors.blue)),
    );
  }
}
