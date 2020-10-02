import 'package:drugStore/components/cart/ui/totals/order_total_with_shipping_ui.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order_management.dart';
import 'package:drugStore/ui/custom_form_field.dart';
import 'package:drugStore/ui/custom_province_form_field.dart';
import 'package:flutter/material.dart';

class CartClientInformation extends StatefulWidget {
  final GlobalKey<FormState> form = new GlobalKey();
  final OrderManagement manager;

  CartClientInformation(this.manager);

  @override
  State<StatefulWidget> createState() => _CartClientInformationState();

  Map<String, dynamic> get data => _CartClientInformationState.data;
}

class _CartClientInformationState extends State<CartClientInformation> {
  static String _validator(
      AppTranslations translator, String value, String regex, int min, int max,
      {bool required = true}) {
    if (!required && (value == null || value.isEmpty)) {
      return null;
    } else if (required && value.isEmpty) {
      return translator.text('required_field');
    } else if (min != null && value.length < min) {
      return "${translator.text('min_length')} $min";
    } else if (max != null && value.length > max) {
      return "${translator.text('max_length')} $max";
    } else if (required && regex != null && !RegExp(regex).hasMatch(value)) {
      return translator.text('invalid_pattern');
    } else {
      return null;
    }
  }

  static Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .95;
    final double paddingWidth = deviceWidth - targetWidth;

    final theme = Theme.of(context);
    final translator = AppTranslations.of(context);

    data = widget.manager.order.client.toJson(false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingWidth),
      child: Form(
        key: widget.form,
        child: Column(
          children: <Widget>[
            // Name
            CustomFormField(
                title: translator.text('order_client_name'),
                initialValue: data['name'],
                onSave: (value) => data['name'] = value,
                onChanged: (value) => widget.manager
                    .setOrderClientFields({'name': value}, notify: false),
                validator: (value) =>
                    _validator(translator, value, null, 3, 50),
                color: theme.accentColor),
            // Phone
            CustomFormField(
              title: translator.text('order_client_phone'),
              initialValue: data['phone'],
              onSave: (value) => data['phone'] = value,
              onChanged: (value) => widget.manager.setOrderClientFields(
                {'phone': value},
                notify: false,
              ),
              validator: (value) => _validator(translator, value, null, 11, 14),
              color: theme.accentColor,
              keyboardType: TextInputType.number,
            ),
            // Province
            CustomProvinceFormField(
              title: translator.text('order_client_province'),
              initialValue: widget.manager
                      .getClientProvince(data['province'])
                      ?.getName(context) ??
                  '',
              onSave: (int value) {
                data['province'] = value;
                widget.manager.setOrderClientFields({'provinceId': value});
              },
              color: theme.accentColor,
            ),
            // Address
            CustomFormField(
                title: translator.text('order_client_address'),
                initialValue: data['address'],
                onSave: (value) => data['address'] = value,
                onChanged: (value) => widget.manager.setOrderClientFields(
                      {'address': value},
                      notify: false,
                    ),
                validator: (value) =>
                    _validator(translator, value, null, 3, 50, required: true),
                color: theme.accentColor),
            CustomFormField(
                title: translator.text('order_client_notes'),
                initialValue: data['notes'],
                onSave: (value) => data['notes'] = value,
                onChanged: (value) => widget.manager.setOrderClientFields(
                      {'notes': value},
                      notify: false,
                    ),
                validator: (value) => _validator(
                    translator, value, null, 3, 300,
                    required: false),
                color: theme.accentColor),
            // Summary
            OrderTotalWithShippingUi(widget.manager.order),
          ],
        ),
      ),
    );
  }
}
