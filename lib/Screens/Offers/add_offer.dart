import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/service_model.dart';
import 'package:flutter/material.dart';

class AddOffer extends StatefulWidget {
  static String route = "/addOffer";

  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  List<String> demoServList = ["SERV11", "SERV22", "SERV33"];
  final TextEditingController titleArController = TextEditingController();
  final TextEditingController titleEnController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController offerDescController = TextEditingController();
  List<Service> servicesList;
  Service service;
  bool isLoading;

  @override
  void initState() {
    servicesList = List();
    _getServices();
    super.initState();
  }

  _getServices() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseManager().getServices();
      if (querySnapshot.documents.length > 0) {
        setState(() {
          servicesList = Service.fromListMap(docList: querySnapshot.documents);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  _handleMainServiceChange(Service value) {
    setState(() {
      service = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new offer"),
          elevation: 0.0,
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: Screen.screenWidth * 0.12,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text("Select service"),
                        value: service,
                        isExpanded: true,
                        onChanged: _handleMainServiceChange,
                        items: servicesList
                            .map((serv) => DropdownMenuItem(
                                  child: Text(serv.nameEn),
                                  value: serv,
                                ))
                            .toList(),
                      ),
                    )
                  ),
                  Container(
                    height: 16.0,
                  ),
                  Text("Title Arabic"),
                  Container(
                    height: 8.0,
                  ),
                  Container(
                    height: Screen.screenWidth * 0.12,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: TextField(
                      controller: descController,
                      decoration: InputDecoration.collapsed(
                          hintText: ""),
                    ),
                  ),
                  Container(
                    height: 16.0,
                  ),
                  Text("Title English"),
                  Container(
                    height: 8.0,
                  ),
                  Container(
                    height: Screen.screenWidth * 0.12,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: TextField(
                      controller: descController,
                      decoration: InputDecoration.collapsed(
                          hintText: ""),
                    ),
                  ),
                  Container(
                    height: 16.0,
                  ),
                  Text("Desc Arabic"),
                  Container(
                    height: 8.0,
                  ),
                  Container(
                    height: Screen.screenWidth * 0.25,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: TextField(
                      controller: offerDescController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration.collapsed(
                          hintText: ""),
                    ),
                  ),
                  Container(
                    height: 16.0,
                  ),
                  Text("Desc English"),
                  Container(
                    height: 8.0,
                  ),
                  Container(
                    height: Screen.screenWidth * 0.25,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: TextField(
                      controller: offerDescController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration.collapsed(
                          hintText: ""),
                    ),
                  ),
                  Container(
                    height: 16.0,
                  ),
                  Text("Price"),
                  Container(
                    height: 8.0,
                  ),
                  Container(
                    height: Screen.screenWidth * 0.12,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: TextField(
                      controller: descController,
                      decoration: InputDecoration.collapsed(
                          hintText: ""),
                    ),
                  ),
                  Container(
                    height: 16.0,
                  ),
                  Text("Qauntity"),
                  Container(
                    height: 8.0,
                  ),
                  Container(
                    height: Screen.screenWidth * 0.12,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: TextField(
                      controller: descController,
                      decoration: InputDecoration.collapsed(
                          hintText: ""),
                    ),
                  ),
                ],
              ),
            ))
        );
  }
}
