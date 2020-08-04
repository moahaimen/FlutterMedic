import 'package:flutter/material.dart';

class OrderItemQuantity extends StatefulWidget {
  final int initQuantity;
  final void Function(int qunatity) onQuantity;

  OrderItemQuantity({@required this.onQuantity, @required this.initQuantity});

  @override
  State<OrderItemQuantity> createState() =>
      OrderItemQuantityState(this.onQuantity);
}

class OrderItemQuantityState extends State<OrderItemQuantity> {
  int quantity = 1;
  void Function(int quantity) onQuantity;

  OrderItemQuantityState(this.onQuantity);

  @override
  void initState() {
    super.initState();
    this.quantity = widget.initQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          color: Theme
              .of(context)
              .accentColor,
          icon: Icon(
            Icons.remove_circle,
          ),
          onPressed: _decreasePiecesCount,
          padding: EdgeInsets.symmetric(horizontal: 2),
        ),
        Expanded(
          child: Text(
            this.quantity.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
        ),
        IconButton(
          color: Theme
              .of(context)
              .accentColor,
          icon: Icon(
            Icons.add_circle,
          ),
          onPressed: _increasePiecesCount,
          padding: EdgeInsets.symmetric(horizontal: 2),
        )
      ],
    );
  }

  void _increasePiecesCount() {
    setState(() {
      this.quantity++;
      this.onQuantity(this.quantity);
    });
  }

  void _decreasePiecesCount() {
    if (this.quantity == 1) {
      return;
    }
    setState(() {
      this.quantity--;
      this.onQuantity(this.quantity);
    });
  }
}
