import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class AddOffer extends StatefulWidget {
  static String route = "/addOffer";

  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  List<String> demoServList = ["SERV11", "SERV22", "SERV33"];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController offerDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Hi offer "),),
      // padding: EdgeInsets.all(16),
      // margin: EdgeInsets.only(bottom: 16),
      // child: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       Text("Serv Name Arabic"),
      //       Container(height: 8.0,),
      //       Container(
      //         height: Screen.screenWidth * 0.12,
      //         alignment: Alignment.centerLeft,
      //         padding: EdgeInsets.symmetric(horizontal: 8),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border.all(color: Colors.black, width: 2),
      //         ),
      //         child: TextField(
      //           controller: nameController,
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Enter serv name"
      //           ),
      //         ),
      //       ),
      //       Container(height: 16.0,),
      //       Text("Serv Name English"),
      //       Container(height: 8.0,),
      //       Container(
      //         height: Screen.screenWidth * 0.12,
      //         alignment: Alignment.centerLeft,
      //         padding: EdgeInsets.symmetric(horizontal: 8),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border.all(color: Colors.black, width: 2),
      //         ),
      //         child: TextField(
      //           controller: nameController,
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Enter serv name"
      //           ),
      //         ),
      //       ),
      //       Container(height: 16.0,),
      //       Text("Serv Desc Arabic"),
      //       Container(height: 8.0,),
      //       Container(
      //         height: Screen.screenWidth * 0.12,
      //         alignment: Alignment.centerLeft,
      //         padding: EdgeInsets.symmetric(horizontal: 8),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border.all(color: Colors.black, width: 2),
      //         ),
      //         child: TextField(
      //           controller: descController,
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Enter serv desc"
      //           ),
      //         ),
      //       ),
      //       Container(height: 16.0,),
      //       Text("Serv Desc English"),
      //       Container(height: 8.0,),
      //       Container(
      //         height: Screen.screenWidth * 0.12,
      //         alignment: Alignment.centerLeft,
      //         padding: EdgeInsets.symmetric(horizontal: 8),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border.all(color: Colors.black, width: 2),
      //         ),
      //         child: TextField(
      //           controller: descController,
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Enter serv desc"
      //           ),
      //         ),
      //       ),
      //       Container(height: 16.0,),
      //       Text("Offer Desc Arabic"),
      //       Container(height: 8.0,),
      //       Container(
      //         height: Screen.screenWidth * 0.25,
      //         alignment: Alignment.centerLeft,
      //         padding: EdgeInsets.all(8),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border.all(color: Colors.black, width: 2),
      //         ),
      //         child: TextField(
      //           controller: offerDescController,
      //           keyboardType: TextInputType.multiline,
      //           maxLines: 5,
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Enter offer desc"
      //           ),
      //         ),
      //       ),
      //       Container(height: 16.0,),
      //       Text("Offer Desc English"),
      //       Container(height: 8.0,),
      //       Container(
      //         height: Screen.screenWidth * 0.25,
      //         alignment: Alignment.centerLeft,
      //         padding: EdgeInsets.all(8),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border.all(color: Colors.black, width: 2),
      //         ),
      //         child: TextField(
      //           controller: offerDescController,
      //           keyboardType: TextInputType.multiline,
      //           maxLines: 5,
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Enter offer desc"
      //           ),
      //         ),
      //       ),
      //       Container(height: 16.0,),
      //       Text("Price"),
      //       Container(height: 8.0,),
      //       Container(
      //         height: Screen.screenWidth * 0.12,
      //         alignment: Alignment.centerLeft,
      //         padding: EdgeInsets.symmetric(horizontal: 8),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border.all(color: Colors.black, width: 2),
      //         ),
      //         child: TextField(
      //           controller: descController,
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Enter serv desc"
      //           ),
      //         ),
      //       ),
      //       Container(height: 16.0,),
      //       Text("Qauntity"),
      //       Container(height: 8.0,),
      //       Container(
      //         height: Screen.screenWidth * 0.12,
      //         alignment: Alignment.centerLeft,
      //         padding: EdgeInsets.symmetric(horizontal: 8),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border.all(color: Colors.black, width: 2),
      //         ),
      //         child: TextField(
      //           controller: descController,
      //           decoration: InputDecoration.collapsed(
      //             hintText: "Enter serv desc"
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // )
      
      //Center(child: Text("Hi offer"),),
    );
  }
}