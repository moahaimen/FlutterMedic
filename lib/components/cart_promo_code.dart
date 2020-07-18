import 'package:drugStore/models/order.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

enum CartPromoCodeStatus {
  Clean,
  Verefying,
  Active,
  InActive,
}

class CartPromoCode extends StatefulWidget {
  final StateModel state;
  final GlobalKey<FormState> form;

  CartPromoCode({@required this.state, @required this.form});

  @override
  State<StatefulWidget> createState() {
    return _CartPromoCodeState(state: this.state, form: this.form);
  }

  Map<String, dynamic> get data => _CartPromoCodeState.data;

  bool get active =>
      _CartPromoCodeState.currentStatus == CartPromoCodeStatus.Active;
}

class _CartPromoCodeState extends State<CartPromoCode> {
  static CartPromoCodeStatus currentStatus = CartPromoCodeStatus.Clean;

  static Widget buildOrderTotal(Order order, dynamic promoCode,
      ThemeData theme) {
    return Card(
      color: Colors.white70,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12.5),
          child: Column(
            children: [
              Text(
                'Total with Promo Code',
                style: theme.textTheme.bodyText2.copyWith(color: Colors.red),
              ),
              Row(
                children: [
                  Text(
                    '${order.total.toString()} \$',
                    style: theme.accentTextTheme.bodyText1.copyWith(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '${order.totalWithCode(promoCode)} \$',
                    style: theme.accentTextTheme.headline6,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final StateModel state;
  final GlobalKey<FormState> form;
  static Map<String, dynamic> data = Map();
  final TextEditingController _controller = TextEditingController();

  _CartPromoCodeState({@required this.state, @required this.form});

  Widget _buildPromoCodeField(BuildContext context) {
    return TextFormField(
      controller: _controller,
      cursorColor: Theme
          .of(context)
          .accentColor,
      autofocus: true,
      autovalidate: true,
      decoration: InputDecoration(
          labelText: "Promo Code",
          suffixIcon: getFieldPrefix(),
          enabled: currentStatus != CartPromoCodeStatus.Verefying,
          labelStyle: TextStyle(color: Theme
              .of(context)
              .accentColor)),
      validator: _checkPromoCodeValidation,
      onSaved: (String value) => data['code'] = value,
      onEditingComplete: _checkPromoCodeActivation,
    );
  }

  Widget getFieldPrefix() {
    switch (currentStatus) {
      case CartPromoCodeStatus.Verefying:
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
          ),
          width: 10,
          height: 10,
        );
      case CartPromoCodeStatus.Active:
        return Icon(Icons.check_circle, color: Colors.lightGreen);
      case CartPromoCodeStatus.InActive:
        return Icon(Icons.close, color: Colors.red);
      case CartPromoCodeStatus.Clean:
        return null;
    }
    return null;
  }

  String _checkPromoCodeValidation(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (value.length != 8) {
      return "Promo Code length must be 8 characters length";
    }
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
      return "Invalid inactiveqy field text pattern";
    }

    return null;
  }

  void _checkPromoCodeActivation() {
    setState(() => currentStatus = CartPromoCodeStatus.Verefying);
    this.state.verifyPromoCodeActivation(_controller.value.text).then((active) {
      print(active);
      if (active == null) {
        setState(() => currentStatus = CartPromoCodeStatus.InActive);
        Toast.show(
            'Promo Code ${_controller.value.text} is not active', context);
        return;
      }
      data['id'] = active['id'];
      data['type'] = active['type'];
      data['discount'] = active['discount'];
      data['code'] = active['code'];
      this.state.setOrderPromoCode(data['code']);
      setState(() => currentStatus = CartPromoCodeStatus.Active);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .95;
    final double paddingWidth = deviceWidth - targetWidth;

    final children = <Widget>[];

    children.add(_buildPromoCodeField(context));
    print(currentStatus);
    if (currentStatus == CartPromoCodeStatus.Active) {
      children.add(SizedBox(
        height: 10,
      ));
      children.add(buildOrderTotal(this.state.order, data, Theme.of(context)));
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingWidth, vertical: 15),
        child: Form(
          key: form,
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
