import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/discount_model.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiscountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DiscountPageContent(),
    );
  }
}

class DiscountPageContent extends StatefulWidget {
  @override
  _DiscountPageContentState createState() => _DiscountPageContentState();
}

class _DiscountPageContentState extends State<DiscountPageContent> {
  late AppBloc _appBloc;
  List<DiscountInfo> _discountList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: _appBloc.discountListDocument,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          _discountList =
              DiscountInfo.fromMapList(discountDocDataList: snapshot.data!.docs);
          return _discountList.isEmpty
              ? NoData()
              : DiscountList(
                  discountList: _discountList,
                );
        });
  }
}

class DiscountList extends StatelessWidget {
  DiscountList({Key? key, required this.discountList}) : super(key: key);

  final List<DiscountInfo> discountList;

  void _onTap(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DiscountDetails(
              discountInfo: discountList[index],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: discountList.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.black12,
      ),
      itemBuilder: (_, index) {
        DiscountInfo discount = discountList[index];
        bool isValid = discount.isValid ?? false;
        IconData icon = AppLocalizations.of(context).isArabic()
            ? Icons.keyboard_arrow_left
            : Icons.keyboard_arrow_right;
        BoxBorder border = AppLocalizations.of(context).isArabic()
            ? Border(
                right: BorderSide(
                    width: 4, color: isValid ? Colors.green : Colors.red))
            : Border(
                left: BorderSide(
                    width: 4, color: isValid ? Colors.green : Colors.red));

        return Container(
          decoration: BoxDecoration(
            border: border,
          ),
          child: ListTile(
            onTap: () => _onTap(context, index),
            title: Row(
              children: <Widget>[
                Expanded(child: Text(discount.code ?? '')),
                Text("${discount.percent}%")
              ],
            ),
            subtitle: Text(discount.dateUpdate ?? ''),
            trailing: Icon(
              icon,
              color: Colors.black12,
            ),
          ),
        );
      },
    ));
  }
}

class DiscountDetails extends StatefulWidget {
  DiscountDetails({Key? key, required this.discountInfo}) : super(key: key);
  final DiscountInfo discountInfo;

  @override
  _DiscountDetailsState createState() => _DiscountDetailsState();
}

class _DiscountDetailsState extends State<DiscountDetails> {
  late DiscountInfo _discountInfo;
  late String _buttonTitle;
  late FirebaseManager _firebaseManager;
  late bool _isValid;
  late String _isValidTitle;

  @override
  void initState() {
    _discountInfo = widget.discountInfo;
    _isValid = _discountInfo.isValid ?? false;
    _firebaseManager = FirebaseManager();
    super.initState();
  }

  void _showConformatiomAlert() {
    String message = AppLocalizations.of(context)
        .translate(LocalizedKey.discountCodeDetailsAlertMessage);
    Alert().conformation(
        context,
        AppLocalizations.of(context)
            .translate(LocalizedKey.conformationAlertTitle),
        message,
        () => _handleChangeStatus());
  }

  void _handleChangeStatus() async {
    final bool isValid = !(_discountInfo.isValid ?? false);
    try {
      Common().loading(context);
      DiscountInfo discount =
          DiscountInfo(id: _discountInfo.id, isValid: isValid);
      await _firebaseManager.updateDiscountCode(discount);
      setState(() {
        _isValid = isValid;
      });
      Common().dismiss(context);
      _showCompletedAlert(
          message: AppLocalizations.of(context)
              .translate(LocalizedKey.discountCodeDetailsSuccessMessage));
    } on PlatformException catch (e) {
      Common().dismiss(context);
      Alert().error(context, e.message ?? '', () => Common().dismiss(context));
    }
  }

  void _showCompletedAlert({String? message}) {
    Alert().success(context, message ?? '', () {
      Common().dismiss(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    _buttonTitle = _isValid
        ? AppLocalizations.of(context)
            .translate(LocalizedKey.discountCodeDetailsButtonTitleEnd)
        : AppLocalizations.of(context)
            .translate(LocalizedKey.discountCodeDetailsButtonTitleRestart);
    _isValidTitle = _isValid
        ? AppLocalizations.of(context)
            .translate(LocalizedKey.discountCodeDetailsValidValueYes)
        : AppLocalizations.of(context)
            .translate(LocalizedKey.discountCodeDetailsValidValueNo);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .translate(LocalizedKey.discountCodeDetailsAppBarTitle)),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            DiscountDetailsRow(
              title: AppLocalizations.of(context)
                  .translate(LocalizedKey.discountCodeDetailsCodeTitle),
              value: _discountInfo.code ?? '',
            ),
            DiscountDetailsRow(
              title: AppLocalizations.of(context)
                  .translate(LocalizedKey.discountCodeDetailsPercentTitle),
              value: _discountInfo.percent.toString(),
            ),
            DiscountDetailsRow(
              title: AppLocalizations.of(context)
                  .translate(LocalizedKey.discountCodeDetailsValidTitle),
              value: _isValidTitle,
            ),
            DiscountDetailsRow(
              title: AppLocalizations.of(context)
                  .translate(LocalizedKey.discountCodeDetailsDateCreateTitle),
              value: _discountInfo.dateCreate ?? '',
            ),
            DiscountDetailsRow(
              title: AppLocalizations.of(context)
                  .translate(LocalizedKey.discountCodeDetailsDateUpdateTitle),
              value: _discountInfo.dateUpdate ?? '',
            ),
            Container(
              height: 16,
            ),
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

class DiscountDetailsRow extends StatelessWidget {
  DiscountDetailsRow({super.key, this.title = "", this.value = ""});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text(
            title + ":",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Container(
            width: 8,
          ),
          Expanded(
            child: Text(value),
          )
        ],
      ),
    );
  }
}
