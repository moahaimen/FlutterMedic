import 'package:flutter/material.dart';

class OrderItemQuantity extends StatefulWidget {
  final int initQuantity;
  final void Function(int qunatity) onQuantity;

  OrderItemQuantity({@required this.onQuantity, @required this.initQuantity});

  @override
  State<OrderItemQuantity> createState() => OrderItemQuantityState();
}

class OrderItemQuantityState extends State<OrderItemQuantity> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.initQuantity != null) {
      this.quantity = widget.initQuantity;
    }
  }

  @override
  void didUpdateWidget(OrderItemQuantity oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.quantity = widget.initQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          color: Theme.of(context).accentColor,
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
          color: Theme.of(context).accentColor,
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
    this.quantity++;
    setState(() => widget.onQuantity(this.quantity));
  }

  void _decreasePiecesCount() {
    if (this.quantity == 1) {
      return;
    }
    this.quantity--;
    setState(() => widget.onQuantity(this.quantity));
  }
}
