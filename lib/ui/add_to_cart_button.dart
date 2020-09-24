import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

class AddToCartButton extends StatefulWidget {
  final int id;

  AddToCartButton({@required this.id});

  @override
  State<AddToCartButton> createState() => _AddToCartButton(this.id);
}

class _AddToCartButton extends State<AddToCartButton> {
  final int id;

  _AddToCartButton(this.id);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel state) {
        final translator = AppTranslations.of(context);

        return state.hasOrderItem(this.id)
            ? RaisedButton.icon(
          onPressed: () =>
              state.removeProductFromOrder(this.id).then(
                      (ok) =>
                      Toast.show(
                          translator.text('cart_item_remove_done_message'),
                          context)),
          label: Text(translator.text('cart_item_added')),
          icon: Icon(Icons.done),
          textColor: Theme
              .of(context)
              .primaryColor,
        )
            : OutlineButton(
          onPressed: () =>
              state.addProductToOrderById(this.id, 1).then(
                      (ok) =>
                      Toast.show(
                          translator.text(ok
                              ? 'cart_item_add_done_message'
                              : 'cart_item_add_failed_message'),
                          context)),
          child: Text(translator.text("add_to_cart").toUpperCase()),
          textColor: Theme
              .of(context)
              .accentColor,
        );
      },
    );
  }
}
