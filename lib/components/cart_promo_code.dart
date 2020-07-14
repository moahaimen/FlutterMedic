import 'package:drugStore/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CartPromoCode extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  CartPromoCode({@required this.formKey});

  @override
  State<CartPromoCode> createState() =>
      _CartPromoCodeState(formKey: this.formKey);
}

class _CartPromoCodeState extends State<CartPromoCode> {
  final GlobalKey<FormState> formKey;

  bool _verefying = false;
  bool _active = true;

  _CartPromoCodeState({@required this.formKey});

  Widget _buildPromoCodeField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Promo Code"),
        onChanged: _checkPromoCodeActivation,
        validator: (String value) =>
        _verefying
            ? 'Verefying...'
            : !_active ? 'Code not active' : _checkPromoCodeValidation,
        onSaved: _save);
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

  void _checkPromoCodeActivation(String value) {
    setState(() => _verefying = true);
    Http.get(DotEnv().env['checkPromoCodeUrl'].replaceAll(':code', value)).then(
          (response) {
        print('xx $response');
        if (response != null) {
          final data = response as Map<String, dynamic>;
          if (data['id'] != null) {
            setState(() {
              this._active = true;
              this._verefying = false;
            });
            return;
          }
        }
        setState(() {
          this._verefying = false;
          this._active = false;
        });
      },
    );
  }

  void _save(String value) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Form(
        key: formKey,
        child: Card(
          child: _buildPromoCodeField(),
        ),
      ),
    );
  }
}
