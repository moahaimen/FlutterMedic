import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order_management.dart';
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
      builder: (BuildContext context, Widget child, StateModel model) {
        assert(model != null);
        assert(model.order != null);

        final order = model.order;
        final translator = AppTranslations.of(context);

        switch (order.status) {
          case OrderStatus.Null:
            order.restore(model);
            return Center(child: CircularProgressIndicator());
          case OrderStatus.Restoring:
          case OrderStatus.Storing:
          case OrderStatus.Submitting:
            return Center(child: CircularProgressIndicator());
          case OrderStatus.Ready:
            return model.hasOrderItem(this.id)
                ? RaisedButton.icon(
              onPressed: () async {
                await model.order.removeOrderItem(this.id);
                      Toast.show(
                        translator.text('cart_item_remove_done_message'),
                        context,
                      );
              },
              label: Text(translator.text('cart_item_added')),
              icon: Icon(Icons.done),
              textColor: Theme
                  .of(context)
                  .primaryColor,
            )
                : OutlineButton(
              onPressed: () async {
                final ok = await model.addOrderItemById(this.id, 1);
                      Toast.show(
                          translator.text(ok
                              ? 'cart_item_add_done_message'
                              : 'cart_item_add_failed_message'),
                          context);
              },
              child: Text(translator.text("add_to_cart").toUpperCase()),
              textColor: Theme
                  .of(context)
                  .accentColor,
            );
        }
        return null;
      },
    );
  }
}
