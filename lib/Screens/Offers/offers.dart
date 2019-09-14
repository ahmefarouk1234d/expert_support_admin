import 'package:flutter/material.dart';

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
  List<String> offerList;

  @override
  void initState() {
    offerList = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Hooo hooo offer"),),
    );
  }
}

class OfferList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}