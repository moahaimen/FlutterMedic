import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_client.dart';
import 'package:flutter/material.dart';

class CartClientInformation extends StatefulWidget {
  final OrderClient client;
  final GlobalKey<FormState> formKey;

  CartClientInformation({@required this.formKey, @required this.client});

  @override
  State<CartClientInformation> createState() =>
      _CartClientInformationState(formKey: this.formKey, client: this.client);
}

class _CartClientInformationState extends State<CartClientInformation> {
  final GlobalKey<FormState> formKey;
  final OrderClient client;

  _CartClientInformationState({@required this.formKey, @required this.client});

  Widget _buildFormField(
    String title,
    String key,
    void Function(String value) saver,
    String Function(String value) validator,
  ) {
    return Container(
        child: TextFormField(
            decoration: InputDecoration(labelText: title),
            validator: validator,
            onSaved: saver));
  }

  String _typicalStringValidator(String value, String regex, int min, int max,
      {bool required}) {
    if (required != null && required == true && value.isEmpty) {
      return "Required field";
    }
    if (value.length < min) {
      return "Minimum allowed length is $min";
    }
    if (value.length > max) {
      return "Maximum allowed length is $max";
    }
    if (!RegExp(regex).hasMatch(value)) {
      return "Invalid field text pattern";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .95;
    final double paddingWidth = deviceWidth - targetWidth;

    return Card(
      margin: EdgeInsets.zero,
      child: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: paddingWidth),
          shrinkWrap: true,
          reverse: false,
          children: <Widget>[
            // Name
            _buildFormField(
                'Name',
                'name',
                (value) => this.client.name = value,
                (value) =>
                    _typicalStringValidator(value, r'^[A-Za-z0-9 ]+$', 3, 32)),
            SizedBox(height: 10.0),
            // Name
            _buildFormField(
                'Email',
                'email',
                (value) => this.client.email = value,
                (value) =>
                    _typicalStringValidator(value, r'^[A-Za-z0-9]+$', 3, 32)),
            SizedBox(height: 10.0),
            // Name
            _buildFormField(
                'Phone',
                'phone',
                (value) => this.client.phone = value,
                (value) =>
                    _typicalStringValidator(value, r'^[A-Za-z0-9]+$', 3, 32)),
            SizedBox(height: 10.0),
            // Name
            _buildFormField(
                'Province',
                'province',
                (value) => this.client.province = value,
                (value) =>
                    _typicalStringValidator(value, r'^[A-Za-z0-9]+$', 3, 32)),
            SizedBox(height: 10.0),
            // Name
            _buildFormField(
                'Address',
                'address',
                (value) => this.client.address = value,
                (value) =>
                    _typicalStringValidator(value, r'^[A-Za-z0-9 ]+$', 12, 64)),
            SizedBox(height: 10.0),
            _buildFormField(
                'Notes',
                'notes',
                (value) => this.client.note = value,
                (value) => _typicalStringValidator(
                    value, r'^[A-Za-z0-9 ]+$', 0, 300,
                    required: false)),
            SizedBox(height: 10.0),
            // Save
          ],
        ),
      ),
    );
  }

  void save() {}
}
