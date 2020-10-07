import 'package:drugStore/models/contact_us.dart';
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
  Pagination<ContactUs> contactUs;

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
  Pagination<Category> categories;

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

  bool finished = false;

  StateModel(BuildContext context) {
    if (this.products == null) {
      this.products = new SelectablePagination<Product>();
      this.products.initialize(() {
        this.notifyListeners();
      }, Product.fromJson, DotEnv().env['fetchProductsUrl']);
    } else {
      this.products.checkStatus();
    }

    if (this.settings == null) {
      this.settings = new Settings(notifier: () {
        this.notifyListeners();
      });
    } else {
      this.settings.checkStatus();
    }

    if (this.contactUs == null) {
      this.contactUs = new Pagination<ContactUs>();
      this.contactUs.initialize(() {
        this.notifyListeners();
      }, ContactUs.fromJson, DotEnv().env['fetchContactUsUrl']);
    } else {
      this.contactUs.checkStatus();
    }

    if (this.provinces == null) {
      this.provinces = new Pagination<Province>();
      this.provinces.initialize(() {
        this.notifyListeners();
      }, Province.fromJson, DotEnv().env['fetchProvincesUrl']);
    } else {
      this.provinces.checkStatus();
    }

    if (this.order == null) {
      this.order = new OrderManagement(this, () {
        this.notifyListeners();
      });
    } else {
      this.order.checkStatus();
    }

    if (this.categories == null) {
      this.categories = new Pagination<Category>();
      this.categories.initialize(() {
        this.notifyListeners();
      }, Category.fromJson, DotEnv().env['fetchCategoriesUrl']);
    } else {
      this.categories.checkStatus();
    }

    if (this.brands == null) {
      this.brands = new Pagination<Brand>();
      this.brands.initialize(() {
        this.notifyListeners();
      }, Brand.fromJson, DotEnv().env['fetchBrandsUrl']);
    } else {
      this.brands.checkStatus();
    }
  }

  Future<void> fetchModelData(BuildContext context) async {
    notifyListeners();

    await this.loadSettings();
    print('settings');

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

    notifyListeners();
  }

  ///
  /// Fetch contact us information
  ///
  Future<void> fetchContactUs(BuildContext context) async {
    await this.contactUs.load(context);
  }

  ///
  /// Fetch provinces list
  ///
  Future<void> fetchProvinces(BuildContext context) async {
    await this.provinces.load(context);
  }

  ///
  /// Fetch list of categories
  ///
  Future<void> fetchCategories(BuildContext context) async {
    await this.categories.load(context);
  }

  ///
  /// Load settings from preferences
  ///
  Future<void> loadSettings() async {
    await this.settings.load();
  }

  ///
  /// Fetch list of brands
  ///
  Future<void> fetchBrands(BuildContext context) async {
    await this.brands.load(context);
  }

  ///
  /// Fetch list of products
  ///
  Future<void> fetchProducts(BuildContext context) async {
    await this.products.load(context);
  }

  ///
  /// Restore the stored version of _order
  ///
  Future<void> restoreOrder(BuildContext context) async {
    return await this.order.restore(context);
  }
}
