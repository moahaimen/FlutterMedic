import 'package:flutter/material.dart';

import '../utils/state.dart';
import 'order_client.dart';
import 'order_product.dart';
import 'order_promo_code.dart';

class Order {
  static Order fromJson(Map<String, dynamic> data, StateModel model) {
    final productsJson = data['products'] as List<dynamic>;
    final products =
        productsJson.map((e) => OrderProduct.fromJson(e, model)).toList();

    final OrderClient client = OrderClient.fromJson(data['client'], model);
    final OrderPromoCode promoCode =
        OrderPromoCode.fromJson(data['promo_code']);

    return new Order(promoCode: promoCode, client: client, products: products);
  }

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

  Order({
    @required this.client,
    @required this.products,
    this.promoCode,
  });

  int get total => products != null && products.length > 0
      ? products
          .map((e) => e.subTotal)
          .reduce((value, element) => value + element)
      : 0;

  int get totalWithCode {
    if (this.promoCode == null) {
      throw new Exception("PromoCode is null");
    }

    final discount = this.promoCode.discount;
    final total = this.total;

    switch (this.promoCode.type) {
      case PromoCodeType.Constant:
        return (total.toDouble() - discount).round();
      case PromoCodeType.Percentage:
        return (total * ((100 - discount) / 100)).round();
    }

    throw new Exception(
        "Unsupported type promoCode.type=${this.promoCode.type}");
  }

  int get totalWithFees {
    final fees = this.fees;
    return this.promoCode == null
        ? this.total + fees
        : this.totalWithCode + fees;
  }

  int get fees {
    if (this.client == null) {
      throw new Exception("Client is null");
    }

    final province = this.client.province;
    final fees = province != null ? province.fees : 0;

    return fees;
  }
}
