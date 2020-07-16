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
        return state.hasOrderItem(this.id)
            ? RaisedButton.icon(
                onPressed: () => state.removeProductFromOrder(this.id).then(
                    (ok) => Toast.show('Item removed succesfully', context)),
                label: Text('Added'),
                icon: Icon(Icons.done),
                textColor: Theme.of(context).primaryColor,
              )
            : OutlineButton(
                onPressed: () => state.addProductToOrderById(this.id, 1).then(
                    (ok) => Toast.show(
                        ok
                            ? 'Item added succesfully'
                            : 'Failed to add item to cart',
                        context)),
                child: Text(
                  'add to cart'.toUpperCase(),
                ),
                textColor: Theme.of(context).accentColor,
              );
      },
    );
  }
}
