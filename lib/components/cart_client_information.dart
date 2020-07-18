import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';

class CartClientInformation extends StatelessWidget {
  final StateModel state;
  final Map<String, dynamic> data = {
    'name': 'mhd',
    'email': 'mhd@mail.com',
    'phone': '00963992209763',
    'province': 'Damascus',
    'address': 'Midan, Damascus, Syria',
  };
  final GlobalKey<FormState> form;

  CartClientInformation({@required this.state, @required this.form});

//      : this.data = state.client.toJson();

  Widget _buildFormField(String title,
      String key,
      void Function(String value) saver,
      String Function(String value) validator,
      Color color) {
    return Container(
      child: TextFormField(
          initialValue: data[key],
          decoration: InputDecoration(
            labelText: title,
            labelStyle: TextStyle(color: color),
          ),
          cursorColor: color,
          textInputAction: TextInputAction.done,
          autovalidate: true,
          validator: validator,
          onSaved: saver),
    );
  }

  String _typicalStringValidator(String value, String regex, int min, int max,
      {bool required = true}) {
    if (required == true && value.isEmpty) {
      return "Required field";
    }
    if (value.length < min) {
      return "Minimum allowed length is $min";
    }
    if (value.length > max) {
      return "Maximum allowed length is $max";
    }
    if (required && !RegExp(regex).hasMatch(value)) {
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingWidth),
        child: Form(
          key: form,
          child: Column(
            children: <Widget>[
              // Name
              _buildFormField(
                  'Name',
                  'name',
                      (value) => this.data['name'] = value,
                      (value) =>
                      _typicalStringValidator(value, r'^[A-Za-z0-9 ]+$', 3, 32),
                  Theme
                      .of(context)
                      .accentColor),
              SizedBox(height: 10.0),
              // Name
              _buildFormField(
                  'Email',
                  'email',
                      (value) => this.data['email'] = value,
                      (value) =>
                      _typicalStringValidator(
                          value,
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          8,
                          32),
                  Theme
                      .of(context)
                      .accentColor),
              SizedBox(height: 10.0),
              // Name
              _buildFormField(
                  'Phone',
                  'phone',
                      (value) => this.data['phone'] = value,
                      (value) =>
                      _typicalStringValidator(value, r'^[0-9]+$', 14, 14),
                  Theme
                      .of(context)
                      .accentColor),
              SizedBox(height: 10.0),
              // Name
              _buildFormField(
                  'Province',
                  'province',
                      (value) => this.data['province'] = value,
                      (value) =>
                      _typicalStringValidator(value, r'^[A-Za-z0-9 ]+$', 3, 32),
                  Theme
                      .of(context)
                      .accentColor),
              SizedBox(height: 10.0),
              // Name
              _buildFormField(
                  'Address',
                  'address',
                      (value) => this.data['address'] = value,
                      (value) =>
                      _typicalStringValidator(
                          value, r'^[A-Za-z0-9 ,-_]+$', 12, 64),
                  Theme
                      .of(context)
                      .accentColor),
              SizedBox(height: 10.0),
              _buildFormField(
                  'Notes',
                  'notes',
                      (value) => this.data['notes'] = value,
                      (value) =>
                      _typicalStringValidator(
                          value, r'^[A-Za-z0-9 ]+$', 0, 300,
                          required: false),
                  Theme
                      .of(context)
                      .accentColor),
              SizedBox(height: 10.0),
              // Save
            ],
          ),
        ),
      ),
    );
  }
}
