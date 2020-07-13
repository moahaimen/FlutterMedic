import 'package:drugStore/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CartPromoCode extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String promoCode) confirmPromoCode;

  CartPromoCode({@required this.formKey, @required this.confirmPromoCode});

  @override
  State<CartPromoCode> createState() => _CartPromoCodeState(
        formKey: this.formKey,
        confirm: this.confirmPromoCode,
      );
}

class _CartPromoCodeState extends State<CartPromoCode> {
  final GlobalKey<FormState> formKey;
  final void Function(String promoCode) confirm;

  bool _active = false;

  _CartPromoCodeState({@required this.formKey, @required this.confirm});

  Widget _buildPromoCodeField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Promo Code"),
        validator: _checkPromoCodeValidation,
        onSaved: _savePromoCodeInState);
  }

  String _checkPromoCodeValidation(String value) {
    if (value.isEmpty) {
      return "Required field";
    }
    if (value.length != 8) {
      return "Promo Code length must be 8 characters length";
    }
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
      return "Invalid field text pattern";
    }

    return null;
  }

  void _savePromoCodeInState(String value) {
    Http.get(DotEnv().env['checkPromoCodeUrl']).then((value) {
      try {
        setState(() {
          this._active = true;
        });
      } catch (e) {
        setState(() {
          this._active = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          reverse: false,
          children: <Widget>[
            _buildPromoCodeField(),
            Chip(
              label: Text(
                  this._active ? "Valid" : "Code doesn't match our records"),
              avatar: Icon(this._active ? Icons.check_circle : Icons.close),
            )
          ],
        ),
      ),
    );
  }
}
