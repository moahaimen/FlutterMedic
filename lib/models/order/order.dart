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
            new OrderClient.full(data['client'], exchange),
            data['promo_code'] != null
                ? new OrderPromoCode.json(data['promo_code'])
                : null,
            user,
            OrderStatus.toList(data['statuses'] as List));

  double getTotal({bool code = false, bool fees = false}) {
    assert(this.products != null);
    double total = this.products.length > 0
        ? this.products.map((e) => e.subTotal).reduce((value, e) => value + e)
        : 0;

    if (code && this.promoCode != null) {
      try {
        assert(this.promoCode != null);

        final discount = this.promoCode.discount;
        switch (this.promoCode.type) {
          case PromoCodeType.Constant:
            total -= discount;
            break;
          case PromoCodeType.Percentage:
            total -= total * (100 - discount) / 100;
            break;
          default:
            throw "PROMOCODE TYPE NOT SUPPORTED";
        }
      } catch (e) {
        print('getTotal, PROMOCODE IS NULL OR FROM UNSUPPORTED TYPE');
      }
    }

    if (fees && this.client != null && this.client.province != null) {
      try {
        assert(this.client != null);
        assert(this.client.province != null);

        total += this.client.province.fees;
      } catch (e) {
        print('getTotal, CLIENT OR PROVINCE IS NULL');
      }
    }
    return total;
  }

  double get fees {
    try {
      assert(this.client != null);
      assert(this.client.province != null);

      return this.client.province.fees;
    } catch (e) {
      print('fees, CLIENT OR PROVINCE IS NULL');
      return 0.0;
    }
  }

  OrderStatus get status => this.statuses.first;
}
