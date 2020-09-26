import 'dart:convert';

import 'package:drugStore/models/pagination.dart';
import 'package:drugStore/utils/http.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'order.dart';
import 'order_client.dart';
import 'order_product.dart';
import 'order_promo_code.dart';
import 'product.dart';
import 'province.dart';

enum OrderStatus { Null, Ready, Restoring, Storing, Submitting }

class OrderManagement {
  Order _order;
  OrderStatus _status;

  final void Function() notifier;

  OrderManagement(this.notifier) : this._status = OrderStatus.Null;

  Order get order => this._order;

  OrderStatus get status => this._status;

  Future<List<OrderProduct>> getProductsInfo(
      BuildContext context, List<dynamic> productsJson) async {
    final productsId = productsJson.map((e) => e['product_id']).toList();
    final productsIdString = productsId.join(',');

    final pp = (await Http.get(
            context,
            DotEnv()
                .env['fetchOrderProductsUrl']
                .replaceAll(':q', productsIdString)) as List<dynamic>)
        .map((e) => Product.fromJson(e))
        .toList();

    final items = new List<OrderProduct>();
    for (int i = 0; i < pp.length; i++) {
      final p = pp[i];
      final j =
          productsJson.firstWhere((element) => element['product_id'] == p.id);

      items.add(new OrderProduct(product: p, quantity: j['quantity']));
    }

    return items;
  }

  Future<void> restore(StateModel instance) async {
    _status = OrderStatus.Restoring;
    notifier();

    if (instance.provinces.status != PaginationStatus.Ready) {
      await instance.provinces.fetch(null);
    }

    final prefs = await SharedPreferences.getInstance();

    if (prefs.getKeys().contains('_order')) {
      try {
        final String orderString = prefs.getString('_order');
        final Map<String, dynamic> orderData = jsonDecode(orderString);

        print(orderData);
        final Order order = await Order.fromJson(orderData, instance, null);
        this._order = order;
      } catch (e) {
        this._order = Order(client: OrderClient.empty, products: []);
        print(e);
      }
    } else {
      this._order = Order(client: OrderClient.empty, products: []);
      print('ooooooka');
    }

    _status = OrderStatus.Ready;
    notifier();
  }

  Future<void> store() async {
    _status = OrderStatus.Storing;
    notifier();

    final prefs = await SharedPreferences.getInstance();
    final orderString = jsonEncode(this._order.toJson(false));

    final ok = await prefs.setString('_order', orderString);

    if (!ok) {
      throw new Exception("Failed to save on Shared Prefrences");
    }

    print(orderString);
    _status = OrderStatus.Ready;
    notifier();
  }

  Future<bool> submit(BuildContext context) async {
    _status = OrderStatus.Submitting;
    notifier();

    final base64 =
        base64Encode(utf8.encode(jsonEncode(this._order.toJson(true))));

    final response =
        await Http.get(context, "${DotEnv().env['postOrderUrl']}?o=$base64");

    _status = OrderStatus.Ready;
    notifier();

    if (response == null) {
      return false;
    }

    await this.clear();
    return true;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('_order');
    this._order = null;
  }

  ///
  /// Insert the item into list of order's products
  ///
  Future<bool> addOrderItem(OrderProduct item) async {
    if (_order == null || item == null || item.product == null) {
      print('Your request to addOrderItem declined');
      return false;
    }

    _order.products.add(item);
    await this.store();

    notifier();
    return true;
  }

  Future<bool> addOrderItemById(
      int productId, int quantity, List<Product> products) async {
    if (_order == null ||
        productId == null ||
        quantity == null ||
        quantity <= 0) {
      print('Your request to addOrderItemById declined');
      return false;
    }

    final product = products.firstWhere((e) => e.id == productId);
    if (product == null || !product.available) {
      print('Your request to addOrderItemById refused');
      return false;
    }

    final item = new OrderProduct(product: product, quantity: quantity);
    return this.addOrderItem(item);
  }

  bool hasItem(int productId) {
    if (_order == null || productId == null) {
      print('HasItem not working properly');
      return false;
    }
    return this._order.products.any((e) => e.product.id == productId);
  }

  ///
  /// Update quantity of a specific orders' product
  ///
  Future<void> updateOrderItem(int productId, int quantity) async {
    if (_order == null ||
        productId == null ||
        quantity == null ||
        quantity <= 0) {
      print('Your request to updateOrderItem declined');
      return false;
    }

    final item = _order.products.firstWhere((e) => e.product.id == productId);
    if (item == null || !item.product.available) {
      print('Your request to updateOrderItem refused');
      return false;
    }

    item.quantity = quantity;
    await this.store();
    notifier();
  }

  ///
  /// Remove item from order
  ///
  Future<void> removeOrderItem(int productId) async {
    if (_order == null || productId == null) {
      print('Something not working properly');
      return;
    }

    this._order.products.removeWhere((p) => p.product.id == productId);
    await this.store();
    notifier();
  }

  ///
  /// set client information for the current order from instance
  ///
  Future<void> setOrderClient(OrderClient client) async {
    if (_order == null) {
      print('Order refernce is not assigned yet');
      return null;
    }

    this._order.client = client;
    await this.store();
    notifier();
  }

  ///
  /// set client information for the current order from attributes
  ///
  Future<void> setOrderClientFields(
    Map<String, dynamic> fields, {
    List<Province> provinces,
    bool notify = true,
  }) async {
    if (_order == null || _order.client == null) {
      print('Client reference is not assinged yet');
      return;
    }

    if (fields.containsKey('name')) {
      this._order.client.name = fields['name'];
    }

    if (fields.containsKey('phone')) {
      this._order.client.phone = fields['phone'];
    }

    if (fields.containsKey('provinceId')) {
      if (provinces == null || provinces.isEmpty) {
        print('Provinces is null or empty');
        return;
      }
      final province =
          provinces.firstWhere((e) => e.id == fields['provinceId']);

      this._order.client.province = province;
    }

    if (fields.containsKey('address')) {
      this._order.client.address = fields['address'];
    }

    if (fields.containsKey('notes')) {
      this._order.client.notes = fields['notes'];
    }

    if (fields.containsKey('userId')) {
      this._order.client.userId = fields['userId'];
    }

    await this.store();
    if (notify) {
      notifier();
    }
  }

  ///
  /// Set order promo code after verify it's activation
  ///
  Future<bool> setPromoCode(BuildContext context, String promoCode) async {
    final String url =
        DotEnv().env['checkPromoCodeUrl'].replaceAll(':code', promoCode);
    final response = await Http.get(context, url);

    if (response == null) {
      this._order.promoCode = null;
      notifier();
      return false;
    }
    final code = OrderPromoCode.fromJson(response as Map<String, dynamic>);
    _order.promoCode = code;
    _order.promoCode.valid = true;

    await this.store();
    notifier();
    return true;
  }

  ///
  /// Order Components Accessors
  ///

  //
  // Get order client information
  //
  OrderClient get client {
    if (_order == null || _order.client == null) {
      return null;
    }
    return this._order.client;
  }

  //
  // Get order promo code
  //
  OrderPromoCode get promoCode {
    if (_order == null || _order.promoCode == null) {
      return null;
    }
    return this._order.promoCode;
  }

  //
  // Count number of items in Current Order
  //
  String get itemsCount {
    if (_order == null || _order.products == null || _order.products.isEmpty) {
      return '0';
    }
    return _order.products
        .map((e) => e.quantity)
        .toList()
        .reduce((value, e) => value + e)
        .toString();
  }
}
