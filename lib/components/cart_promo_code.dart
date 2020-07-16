import 'package:drugStore/models/order.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

enum CartPromoCodeStatus {
  Valid,
  InValid,
  Verefying,
  InActive,
}

class CartPromoCode extends StatefulWidget {
  final StateModel state;
  final GlobalKey<FormState> form;
  final Map<String, dynamic> data = new Map();

  CartPromoCode({@required this.state, @required this.form});

  @override
  State<StatefulWidget> createState() {
    return _CartPromoCodeState(
        state: this.state, data: this.data, form: this.form);
  }
}

class _CartPromoCodeState extends State<CartPromoCode> {
  static CartPromoCodeStatus currentStatus;

  static Widget buildOrderTotal(Order order, ThemeData theme) {
    return Card(
      color: Colors.white70,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12.5),
          child: Column(
            children: [
              Text(
                'Total',
                style: theme.textTheme.bodyText2.copyWith(color: Colors.red),
              ),
              Text(
                '${order.total.toString()} \$',
                style: theme.accentTextTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final StateModel state;
  final GlobalKey<FormState> form;
  final Map<String, dynamic> data;

  _CartPromoCodeState(
      {@required this.state, @required this.data, @required this.form});

  Widget _buildPromoCodeField(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.lightGreen,
      decoration: InputDecoration(
          labelText: "Promo Code",
          prefix: getFieldPrefix(),
          enabled: currentStatus != CartPromoCodeStatus.Verefying),
      autovalidate: true,
      validator: _checkPromoCodeValidation,
      onSaved: (String value) => data['code'] = value,
      onEditingComplete: _checkPromoCodeActivation,
    );
  }

  Widget getFieldPrefix() {
    switch (currentStatus) {
      case CartPromoCodeStatus.Verefying:
        return CircularProgressIndicator();
      case CartPromoCodeStatus.Valid:
        return Icon(Icons.check_circle, color: Colors.lightGreen);
      case CartPromoCodeStatus.InValid:
      case CartPromoCodeStatus.InActive:
        return Icon(Icons.close, color: Colors.red);
    }
    return null;
  }

  String _checkPromoCodeValidation(String value) {
    if (value.isEmpty) {
      setState(() => currentStatus = CartPromoCodeStatus.InValid);
      return "Required field";
    }
    if (value.length != 8) {
      setState(() => currentStatus = CartPromoCodeStatus.InValid);
      return "Promo Code length must be 8 characters length";
    }
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
      setState(() => currentStatus = CartPromoCodeStatus.InValid);
      return "Invalid inactiveqy field text pattern";
    }

    setState(() => currentStatus = CartPromoCodeStatus.Valid);
    this.data['code'] = value;
    return null;
  }

  void _checkPromoCodeActivation() {
    final code = this.data['code'];
    this.state.verifyPromoCodeActivation(code).then((active) {
      if (!active) {
        setState(() => currentStatus = CartPromoCodeStatus.InActive);
        Toast.show('Promo Code $code is not active', context);
        return;
      }
      setState(() => currentStatus = CartPromoCodeStatus.Valid);
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
    if (currentStatus == CartPromoCodeStatus.Valid) {
      children.add(buildOrderTotal(this.state.order, Theme.of(context)));
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingWidth),
        child: Form(
          key: form,
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
