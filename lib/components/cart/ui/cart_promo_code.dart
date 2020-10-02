import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_management.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

enum CartPromoCodeStatus { Clean, Verefying, Active, InActive }

class CartPromoCode extends StatefulWidget {
  final OrderManagement manager;

  CartPromoCode(this.manager);

  @override
  State<StatefulWidget> createState() => _CartPromoCodeState();

  bool isValid() {
    final Order order = this.manager.order;

    return _CartPromoCodeState.currentStatus == CartPromoCodeStatus.Active &&
        order != null &&
        order.promoCode != null &&
        order.promoCode.code != null &&
        order.promoCode.code.length == 8 &&
        order.promoCode.valid;
  }

  bool isEmpty() {
    return (this.manager.order.promoCode == null ||
            this.manager.order.promoCode.code.isEmpty) &&
        _CartPromoCodeState.controller.text.isEmpty;
  }
}

class _CartPromoCodeState extends State<CartPromoCode> {
  static String getPromoCodeOrDefault(OrderManagement manager) {
    assert(manager != null);
    assert(manager.order != null);

    return manager.order.promoCode?.code ?? '';
  }

  static CartPromoCodeStatus currentStatus = CartPromoCodeStatus.Clean;

  static TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    currentStatus = CartPromoCodeStatus.Clean;
    controller.text = getPromoCodeOrDefault(widget.manager);
  }

  Widget _buildPromoCodeField(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppTranslations translator = AppTranslations.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translator.text('promo_code')),
          Container(
            decoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: TextField(
              textDirection: TextDirection.ltr,
              controller: controller,
              decoration: InputDecoration(
                  hintText: translator.text('promo_code'),
                  suffixIcon: getFieldPrefix(),
                  enabled: currentStatus != CartPromoCodeStatus.Verefying,
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: theme.accentColor)),
              cursorColor: theme.accentColor,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              onChanged: (String value) {
                if (value.length == 8) {
                  _checkPromoCodeActivation();
                }
              },
            ),
          ),
        ],
      ),
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
        return Icon(Icons.error_outline, color: Colors.redAccent);
      case CartPromoCodeStatus.Clean:
        return null;
    }
    return null;
  }

  void _checkPromoCodeActivation() {
    final translator = AppTranslations.of(context);

    setState(() => currentStatus = CartPromoCodeStatus.Verefying);
    widget.manager
        .setPromoCode(this.context, controller.value.text)
        .then((active) {
      if (active == null || !active) {
        setState(() => currentStatus = CartPromoCodeStatus.InActive);
        Toast.show(translator.text('promo_code_in_active'), context);
      } else {
        setState(() => currentStatus = CartPromoCodeStatus.Active);
        Toast.show(translator.text('promo_code_active'), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * .985;
    final double paddingWidth = deviceWidth - targetWidth;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50)),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(horizontal: paddingWidth),
      child: _buildPromoCodeField(context),
    );
  }
}
