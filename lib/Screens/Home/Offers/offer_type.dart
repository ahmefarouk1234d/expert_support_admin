import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Screens/Home/Offers/add_order_offer.dart';
import 'package:expert_support_admin/Screens/Home/Offers/add_packages.dart';
import 'package:flutter/material.dart';

class OfferTypeScreen extends StatelessWidget {
  static String route = "/offerType";

  _onOffersOnServiceTapped(BuildContext context) {
    Navigator.of(context).pushNamed(AddOrderOffer.route);
  }

  _onPackagesTapped(BuildContext context) {
    Navigator.of(context).pushNamed(AddPackages.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations
            .of(context)
            .translate(
              LocalizedKey.selectOfferTypeAppBarTitle
            )
          ),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            OfferTypeListTile(
              title: AppLocalizations
                .of(context)
                .translate(
                  LocalizedKey.offerOnServiceTitle
                ),
              onTap: () => _onOffersOnServiceTapped(context),
            ),
            OfferTypeListTile(
              title:  AppLocalizations
                .of(context)
                .translate(
                  LocalizedKey.offerOnPackagesTitle
                ),
              onTap: () => _onPackagesTapped(context),
            ),
          ],
        )
      )
    );
  }
}

class OfferTypeListTile extends StatelessWidget {
  OfferTypeListTile({Key key, this.title, this.onTap});

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () { onTap(); },
        title: Container(
          padding: EdgeInsets.all(16),
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 1
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0)
            ),
          ),
          child: Text(title)
        ),
      )
    );
  }
}