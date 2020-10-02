import 'package:drugStore/models/order_management.dart';
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

  //
  // Check whether the stateModel is ready to use any of its properties
  //
  bool get ready =>
      settings != null &&
      settings.status == SettingsStatus.Ready &&
      provinces != null &&
      provinces.status == PaginationStatus.Ready &&
      contactUs != null &&
      contactUs.status == PaginationStatus.Ready &&
      brands != null &&
      brands.status == PaginationStatus.Ready &&
      categories != null &&
      categories.status == PaginationStatus.Ready &&
      products != null &&
      products.status == PaginationStatus.Ready &&
      order != null &&
      order.status == OrderStatus.Ready;

  StateModel(BuildContext context) {
    this.products = new SelectablePagination<Product>(
        () => this.notifyListeners(),
        path: DotEnv().env['fetchProductsUrl'],
        cb: (e) => Product.fromJson(e));

    this.settings = new Settings(notifier: () => this.notifyListeners());

    this.contactUs = new Pagination<dynamic>(
        notifier: () => this.notifyListeners(),
        path: DotEnv().env['fetchContactUsUrl'],
        callback: (e) => {
              'key': e['key'],
              'section': e['section'],
              'en_value': e['en_value'],
              'ar_value': e['ar_value'],
              'url': e['url']
            });

    this.provinces = new Pagination<Province>(
        notifier: () => this.notifyListeners(),
        path: DotEnv().env['fetchProvincesUrl'],
        callback: (e) => Province.fromJson(e));

    this.order = new OrderManagement(this, () => this.notifyListeners());

    this.categories = new SelectablePagination<Category>(
        () => this.notifyListeners(),
        path: DotEnv().env['fetchCategoriesUrl'],
        cb: (e) => Category.fromJson(e));

    this.brands = new Pagination<Brand>(
        notifier: () => this.notifyListeners(),
        path: DotEnv().env['fetchBrandsUrl'],
        callback: (e) => Brand.fromJson(e));
  }

  Future<void> fetchModelData(BuildContext context) async {
    notifyListeners();

    await this.fetchProvinces(context);
    print('provinces');
    await this.fetchContactUs(context);
    print('contactUs');

    await this.fetchBrands(context);
    print('brands');
    await this.fetchCategories(context);
    print('categories');

    await this.fetchProducts(context);
    print('products');
    await this.restoreOrder(context);
    print('order ${order.order}');

    await this.loadSettings();
    print('settings');

    notifyListeners();
  }

  ///
  /// Fetch contact us information
  ///
  Future<void> fetchContactUs(BuildContext context) async {
    await this.contactUs.fetch(context, true, true);
  }

  ///
  /// Fetch provinces list
  ///
  Future<void> fetchProvinces(BuildContext context) async {
    await this.provinces.fetch(context, true, true);
  }

  ///
  /// Fetch list of categories
  ///
  Future<void> fetchCategories(BuildContext context) async {
    await this.categories.fetch(context, true, true);
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
    return this.settings.store(data);
  }

  ///
  /// Toggle the current language and store the result in Preferences
  ///
  Future<void> alternateLanguage() {
    return this.settings.alternateLanguage();
  }

  ///
  /// Fetch list of brands
  ///
  Future<void> fetchBrands(BuildContext context) async {
    await this.brands.fetch(context, true, true);
  }

  ///
  /// Fetch list of products
  ///
  Future<void> fetchProducts(BuildContext context) async {
    await this.products.fetch(context, true, true);
  }

  ///
  /// Restore the stored version of _order
  ///
  Future<void> restoreOrder(BuildContext context) async {
    return await this.order.restore(context);
  }
}
