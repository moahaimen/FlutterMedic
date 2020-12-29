import 'package:drugStore/models/order/status.dart';
import 'package:drugStore/models/user.dart';
import 'package:drugStore/utils/state.dart';

import 'order_client.dart';
import 'order_product.dart';
import 'promo_code.dart';

class Order {
  Map<String, dynamic> toJson(bool isPost) {
    final Map<String, dynamic> data = {
      'promo_code': this.promoCode?.toJson(isPost) ?? null,
      'client': this.client.toJson(isPost),
      'products': this.products.map((e) => e.toJson()).toList(),
    };

    return data;
  }

  OrderPromoCode promoCode;
  OrderClient client;
  List<OrderProduct> products;
  User user;
  List<OrderStatus> statuses;

  Order(this.products, this.client, this.promoCode, this.user, this.statuses);

  Order.json(Map<String, dynamic> data, StateModel model)
      : this(
            (data['products'] as List<dynamic>)
                .map((e) => OrderProduct.json(e, model))
                .toList(),
            data['client'] != null
                ? new OrderClient.json(data['client'], model)
                : null,
            data['promo_code'] != null
                ? new OrderPromoCode.json(data['promo_code'])
                : null,
            model.user ?? null,
            []);

  Order.empty() : this([], OrderClient.empty(), null, null, null);

  Order.full(User user, dynamic data, double exchange)
      : this(
            OrderProduct.toList(data['order_products'], exchange),
            new OrderClient.full(data['client']),
            data['promo_code'] != null
                ? new OrderPromoCode.json(data['promo_code'])
                : null,
            user,
            OrderStatus.toList(data['statuses'] as List));

  double get total {
    print(this.toJson(false));
    return products != null && products.length > 0
        ? products
            .map((e) => e.subTotal)
            .reduce((value, element) => value + element)
        : 0;
  }

  double get totalWithCode {
    if (this.promoCode == null) {
      throw new Exception("PromoCode is null");
    }

    final discount = this.promoCode.discount;
    final total = this.total;

    switch (this.promoCode.type) {
      case PromoCodeType.Constant:
        return (total.toDouble() - discount);
      case PromoCodeType.Percentage:
        return (total * ((100 - discount) / 100));
      default:
        throw new Exception("Unsupported PromoCode type");
    }
  }

  double get totalWithFees {
    final fees = this.fees;
    return this.promoCode == null
        ? this.total + fees
        : this.totalWithCode + fees;
  }

  double get fees {
    if (this.client == null) {
      throw new Exception("Client is null");
    }

    final province = this.client.province;
    final fees = province != null ? province.fees : 0;

    return fees * 1.0;
  }

  OrderStatus get status => this.statuses.first;
}
