import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/province.dart';
import 'package:drugStore/ui/order_total_widget.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';

class CartClientInformation extends StatefulWidget {
  final StateModel state;
  final GlobalKey<FormState> form = new GlobalKey();

  CartClientInformation({@required this.state});

  @override
  State<StatefulWidget> createState() =>
      _CartClientInformationState(state: state);

  Map<String, dynamic> get data => _CartClientInformationState.data;
}

class _CartClientInformationState extends State<CartClientInformation> {
  static String _validator(AppTranslations translator, String value,
      String regex, int min, int max,
      {bool required = true}) {
    if (required == true && value.isEmpty) {
      return translator.text('required_field');
    } else if (value.length < min) {
      return "${translator.text('min_length')} $min";
    } else if (value.length > max) {
      return "${translator.text('max_length')} $max";
    } else if (required && regex != null && !RegExp(regex).hasMatch(value)) {
      return translator.text('invalid_pattern');
    } else {
      return null;
    }
  }

  static Widget _buildFormField(String title,
      String initialValue,
      void Function(String value) saver,
      String Function(String value) validator,
      Color color,
      {int maxLines = 1}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Container(
            decoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: TextFormField(
              initialValue: initialValue,
              maxLines: maxLines,
              minLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title,
              ),
              cursorColor: color,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              autovalidate: true,
              validator: validator,
              onSaved: saver,
            ),
          ),
        ],
      ),
    );
  }

  static Future<Province> showProvincesModel(BuildContext context,
      List<Province> provinces, String title) async {
    return showDialog<Province>(
      context: context,
      builder: (BuildContext context) =>
          SimpleDialog(
            title: Text(title),
            children: provinces
                .map((e) =>
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, e);
                  },
                  child: Text(e.getName(context)),
                ))
                .toList(),
          ),
    );
  }

  static Widget _buildProvinceField(String title,
      String initialValue,
      void Function(int value) saver,
      BuildContext context,
      List<Province> provinces,
      Color color,
      AppTranslations translator) {
    final controller = new TextEditingController(text: initialValue);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Container(
            decoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: TextFormField(
              controller: controller,
              minLines: 1,
              maxLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title,
              ),
              cursorColor: color,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              autovalidate: true,
              validator: (String value) {
                if (value == null || value.isEmpty) {
                  return translator.text('required_field');
                } else if (provinces.indexWhere((e) => e.enName == value) ==
                    -1) {
                  return translator.text('province_must_be_valid');
                } else {
                  return null;
                }
              },
//              onSaved: saver,
              onTap: () async {
                final province = await showProvincesModel(
                    context, provinces, translator.text('select_province'));
                saver(province.id);
                controller.text = province.getName(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildOrderSummaryWidget(Order order, List<Province> provinces,
      ThemeData theme, AppTranslations translator) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Total
          Expanded(
            child: OrderTotalWidget(order: order),
          ),
          // Total + Shipping fees
          Expanded(
            child: Card(
              borderOnForeground: true,
              child: Column(
                children: [
                  Text(translator.text("total_with_fees"),
                      style: theme.accentTextTheme.bodyText2),
                  Text("${order.totalWithFees.toString()} \$",
                      style: theme.accentTextTheme.headline6
                          .copyWith(color: theme.accentColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Map<String, dynamic> data;
  final StateModel state;

  _CartClientInformationState({@required this.state}) {
    data = state.client.toJson(false);
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translator = AppTranslations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Form(
        key: widget.form,
        child: Column(
          children: <Widget>[
            // Name
            _buildFormField(
                translator.text('order_client_name'),
                data['name'],
                    (value) => data['name'] = value,
                    (value) => _validator(translator, value, null, 3, 32),
                theme.accentColor),
            // Phone
            _buildFormField(
                translator.text('order_client_phone'),
                data['phone'],
                    (value) => data['phone'] = value,
                    (value) =>
                    _validator(translator, value, r'^[0-9]+$', 14, 14),
                theme.accentColor),
            // Province
            _buildProvinceField(
              translator.text('order_client_province'),
              getProvinceOrDefault(data['province']),
                  (int value) {
                data['province'] = value;
//                state.setOrderClientProvince(value);
              },
              context,
              state.provinces,
              theme.accentColor,
              translator,
            ),
            // Address
            _buildFormField(
                translator.text('order_client_address'),
                data['address'],
                    (value) => data['address'] = value,
                    (value) =>
                    _validator(
                        translator, value, r'^[A-Za-z0-9 ,-_]+$', 12, 64),
                theme.accentColor),
            _buildFormField(
                translator.text('order_client_notes'),
                data['notes'],
                    (value) => data['notes'] = value,
                    (value) =>
                    _validator(
                        translator, value, r'^[A-Za-z0-9 أ-ي]+$', 0, 300,
                        required: false),
                theme.accentColor),
            // Summary
            _buildOrderSummaryWidget(
                state.order, state.provinces, theme, translator),
          ],
        ),
      ),
    );
  }

  String getProvinceOrDefault(int provinceId) {
    if (provinceId == null) {
      print("Province id is null");
      return '';
    }

    final province =
    state.provinces.firstWhere((e) => e.id == provinceId, orElse: null);

    if (province == null) {
      print("Province id doesnot mtach");
      return '';
    }

    print("Province matched");
    return province.getName(context);
  }
}
