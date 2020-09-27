import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/models/order_management.dart';
import 'package:drugStore/models/order_product.dart';
import 'package:drugStore/models/pagination.dart';
import 'package:drugStore/models/province.dart';
import 'package:drugStore/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';

class StateModel extends Model {
  //
  // Provinces
  //
  Pagination<Province> provinces;

  //
  // Contact Us
  //
  Pagination<dynamic> contactUs;

  //
  // Settings
  //
  Settings settings;

  //
  // Brands
  //
  Pagination<Brand> brands;

  //
  // Categories
  //
  SelectablePagination<Category> categories;

  //
  // Products
  //
  SelectablePagination<Product> products;

  List<Product> get featured =>
      this.products != null && this.products.data != null
          ? List.from(this.products.data.where((e) => e.isMain).take(5))
          : null;

  //
  // Cart Management
  //
  OrderManagement order;

  bool _fetching;

  bool get fetching => _fetching;

  StateModel(BuildContext context) {
    this.products = new SelectablePagination<Product>(
            () => this.notifyListeners(),
        path: DotEnv().env['fetchProductsUrl'],
        cb: (e) => Product.fromJson(e));

    this.settings = new Settings(() => this.notifyListeners());

    this.contactUs = new Pagination<dynamic>(() => this.notifyListeners(),
        path: DotEnv().env['fetchContactUsUrl'],
        callback: (e) =>
        {
          'key': e['key'],
          'section': e['section'],
          'en_value': e['en_value'],
          'ar_value': e['ar_value'],
          'url': e['url']
        });

    this.provinces = new Pagination<Province>(() => this.notifyListeners(),
        path: DotEnv().env['fetchProvincesUrl'],
        callback: (e) => Province.fromJson(e));

    this.order = new OrderManagement(() => this.notifyListeners());

    this.categories = new SelectablePagination<Category>(
            () => this.notifyListeners(),
        path: DotEnv().env['fetchCategoriesUrl'],
        cb: (e) => Category.fromJson(e));

    this.brands = new Pagination<Brand>(() => this.notifyListeners(),
        path: DotEnv().env['fetchBrandsUrl'],
        callback: (e) => Brand.fromJson(e));

    fetchModelData(context);
  }

  Future<void> fetchModelData(BuildContext context) async {
    _fetching = true;
    notifyListeners();

    await this.fetchProvinces(context);
    await this.fetchContactUs(context);

    await this.fetchBrands(context);
    await this.fetchCategories(context);

    await this.fetchProducts(context);
    await this.restoreOrder();

    await this.loadSettings();

    _fetching = false;
    notifyListeners();
  }

  ///
  /// Fetch contact us information
  ///
  Future<void> fetchContactUs(BuildContext context) async {
    await this.contactUs.fetch(context);
  }

  ///
  /// Fetch provinces list
  ///
  Future<void> fetchProvinces(BuildContext context) async {
    await this.provinces.fetch(context);
  }

  ///
  /// Fetch list of categories
  ///
  Future<void> fetchCategories(BuildContext context) async {
    await this.categories.fetch(context);
  }

  ///
  /// Load settings from preferences
  ///
  Future<void> loadSettings() {
    return this.settings.load();
  }

  ///
  /// Upload settings from preferences
  ///
  Future<void> storeSettings(Map<String, dynamic> data) {
    return this.settings.store(data, () => this.notifyListeners());
  }

  ///
  /// Toggle the current language and store the result in Preferences
  ///
  Future<void> alternateLanguage() {
    return this.settings.alternateLanguage(() => this.notifyListeners());
  }

  ///
  /// Fetch list of brands
  ///
  Future<void> fetchBrands(BuildContext context) async {
    await this.brands.fetch(context);
  }

  ///
  /// Fetch list of products
  ///
  Future<void> fetchProducts(BuildContext context) async {
    await this.products.fetch(context);
  }

  ///
  /// Restore the stored version of order
  ///
  Future<void> restoreOrder() async {
    return await this.order.restore(this);
  }

  ///
  /// Persist the active version of order
  ///
  Future<void> storeOrder() async {
    return await this.order.store();
  }

  ///
  /// Post order
  ///
  Future<bool> submitOrder(BuildContext context) async {
    return await this.order.submit(context);
  }

  ///
  /// Insert the item into list of order's products
  ///
  Future<bool> addOrderItem(OrderProduct item) async {
    return this.order.addOrderItem(item);
  }

  Future<bool> addOrderItemById(int productId, int quantity) async {
    return this.order.addOrderItemById(productId, quantity, this.products.data);
  }

  bool hasOrderItem(int productId) {
    return this.order.hasItem(productId);
  }

  ///
  /// Update quantity of a specific orders' product
  ///
  Future<void> updateOrderItem(int productId, int quantity) async {
    return this.order.updateOrderItem(productId, quantity);
  }

  ///
  /// Remove order item
  ///
  Future<void> removeOrderItem(int productId) async {
    return this.order.removeOrderItem(productId);
  }

  ///
  /// set order client
  ///
  Future<void> setOrderClient(OrderClient client) async {
    return this.order.setOrderClient(client);
  }

  ///
  /// set order client
  ///
  Future<void> setOrderClientDetails(Map<String, dynamic> fields,
      {bool notify = true}) async {
    return this.order.setOrderClientFields(fields,
        notify: notify, provinces: this.provinces.data);
  }

  ///
  /// Set order promo code after verify it's activation
  ///
  Future<bool> setPromoCode(BuildContext context, String promoCode) async {
    return this.order.setPromoCode(context, promoCode);
  }
}
