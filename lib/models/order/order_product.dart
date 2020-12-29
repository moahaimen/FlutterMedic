import 'package:drugStore/utils/state.dart';

import '../product.dart';

class OrderProduct {
  static List<OrderProduct> toList(List<dynamic> products, double exchange) {
    return products
        .map((p) => new OrderProduct(
            Product.json(p['product'], exchange), p['quantity']))
        .toList();
  }

  int quantity;
  final Product product;

  OrderProduct(this.product, this.quantity);

  OrderProduct.json(Map<String, dynamic> data, StateModel model)
      : this(model.products.firstWhere((e) => e.id == data['product_id']),
            data['quantity']);

  double get subTotal {
    if (this.quantity == null && this.product == null) {
      return 0;
    }
    return this.quantity * this.product.price;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': this.product.id,
      'quantity': this.quantity,
    };

    return data;
  }
}
