import 'dart:convert';

import 'package:drugStore/localization/application.dart';
import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/models/order_product.dart';
import 'package:drugStore/models/order_promo_code.dart';
import 'package:drugStore/models/province.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'http.dart';

class StateModel extends Model {
  //
  // Provinces
  //
  bool _provincesLoading = false;
  List<Province> _provinces;

  bool get provincesLoading => this._provincesLoading;

  List<Province> get provinces => List.from(this._provinces);

  //
  // Contact Us
  //
  bool _contactUsLoading = false;
  Map<String, dynamic> _contactUs;

  bool get contactUsLoading => this._contactUsLoading;

  Map<String, dynamic> get contactUs => Map.from(_contactUs);

  //
  // Settings
  //
  bool _settingsLoading = false;
  final Map<String, dynamic> _defaultSettings = {
    'locale': 'ar',
    'notifications': true
  };
  Map<String, dynamic> _settings;

  bool get settingsLoading => this._settingsLoading;

  Map<String, dynamic> get settings => Map.from(_settings);

  //
  // Brands
  //
  bool _brandsLoading = false;
  List<Brand> _brands;

  bool get brandsLoading => this._brandsLoading;

  List<Brand> get brands => List.from(this._brands);

  //
  // Categories
  //
  bool _categoriesLoading = false;
  List<Category> _categories;

  bool get categoriesLoading => this._categoriesLoading;

  List<Category> get categories => List.from(this._categories);

  //
  // Products
  //
  bool _productsLoading = false;
  var _selectedProduct;
  List<Product> _products;

  bool get productsLoading => this._productsLoading;

  Product get selectedProduct =>
      this._products.firstWhere((e) => e.id == _selectedProduct);

  Product get selectedOrFirstProduct {
    if (_products == null || _products.length == 0) return null;

    final i = _products.firstWhere((e) => e.id == _selectedProduct);

    if (i != null) return i;
    return _products.first;
  }

  List<Product> get products => List.from(this._products);

  List<Product> get mainProducts =>
      List.from(this._products.where((e) => e.isMain).take(5));

  ///
  /// Cart Management
  ///
  bool _orderRestoring = true;
  bool _orderUploading = false;
  Order _order;

  bool get orderUploading => this._orderUploading;

  bool get orderRestoring => this._orderRestoring;

  Order get order => this._order;

  StateModel(BuildContext context) {
    _initializeModelData(context);
  }

  void _initializeModelData(BuildContext context) {
    this._brands = [];
    this._categories = [];
    this._products = [];
    this._provinces = [];

    this.fetchModelData(context);
  }

  void fetchModelData(BuildContext context) {
    this.fetchBrands(context);
    this.fetchCategories(context);
    this.fetchProducts(context).then((value) => this.restoreStoredOrder());
    this.loadSettings();
    this.fetchContactUs(context);
    this.fetchProvinces(context);
  }

  ///
  /// Fetch contact us information
  ///
  Future<void> fetchContactUs(BuildContext context) {
    _contactUsLoading = true;
    notifyListeners();

    return Http.get(context, DotEnv().env['fetchContactUsUrl'])
        .then((dynamic contactUs) {
      if (contactUs == null) {
        _contactUsLoading = false;
        notifyListeners();
        return;
      }
      final List<dynamic> xx = contactUs as List<dynamic>;
      _contactUs = new Map();

      xx.forEach((e) {
        if (!_contactUs.containsKey(e['section'])) {
          _contactUs[e['section']] = new Map();
        }
        _contactUs[e['section']][e['key']] = {
          'en_value': e['en_value'],
          'ar_value': e['ar_value'],
          'url': e['url'],
        };
      });

      _contactUsLoading = false;
      notifyListeners();
    });
  }

  ///
  /// Fetch provinces list
  ///
  Future<void> fetchProvinces(BuildContext context) {
    _provincesLoading = true;
    notifyListeners();

    return Http.get(context, DotEnv().env['fetchProvincesUrl'])
        .then((dynamic provinces) {
      if (provinces == null) {
        this._provincesLoading = false;
        this.notifyListeners();
        return;
      }

      this._provinces =
          provinces.map<Province>((e) => Province.fromJson(e)).toList();

      this._provincesLoading = false;
      this.notifyListeners();
    });
  }

  ///
  /// Fetch list of categories
  ///
  Future<void> fetchCategories(BuildContext context) {
    this._categoriesLoading = true;
    this.notifyListeners();

    return Http.get(context, DotEnv().env['fetchCategoriesUrl'])
        .then((dynamic categories) {
      if (categories == null) {
        this._categoriesLoading = false;
        this.notifyListeners();
        return;
      }

      this._categories =
          categories.map<Category>((e) => Category.fromJson(e)).toList();

      this._categoriesLoading = false;
      this.notifyListeners();
    });
  }

  ///
  /// Load settings from preferences
  ///
  Future<void> loadSettings() {
    this._settingsLoading = true;
    this.notifyListeners();

    return SharedPreferences.getInstance().then((prefs) {
      this._settings = prefs.getString('_settings') != null
          ? json.decode(prefs.getString('_settings'))
          : _defaultSettings;

      this._settingsLoading = false;
      this.notifyListeners();
    });
  }

  ///
  /// Upload settings from preferences
  ///
  Future<void> setSettings(Map<String, dynamic> newSettings) {
    this._settingsLoading = true;
    this.notifyListeners();

    return SharedPreferences.getInstance().then((prefs) {
      this._settings = newSettings;

      final String value = json.encode(newSettings);
      prefs.setString('_settings', value);

      this._settingsLoading = false;
      this.notifyListeners();
    });
  }

  //
  // If the current language 'en' then change to 'ar' and vice versa
  //
  Future<void> toggleLanguage() async {
    final String current = this._settings['locale'];

    this._settings['locale'] = current == 'en' ? 'ar' : 'en';
    this
        .setSettings(this._settings)
        .then((value) => application.setLocale(settings['locale']));
  }

  ///
  /// Fetch list of brands
  ///
  Future<void> fetchBrands(BuildContext context) {
    this._brandsLoading = true;
    this.notifyListeners();

    return Http.get(context, DotEnv().env['fetchBrandsUrl'])
        .then((dynamic result) {
      if (result == null) {
        this._brandsLoading = false;
        this.notifyListeners();
        return;
      }
      this._brands = result.map<Brand>((e) => Brand.fromJson(e)).toList();

      this._brandsLoading = false;
      this.notifyListeners();
    });
  }

  ///
  /// Fetch list of products
  ///
  Future<void> fetchProducts(BuildContext context) {
    this._productsLoading = true;
    this.notifyListeners();

    return Http.get(context, DotEnv().env['fetchProductsUrl'])
        .then((dynamic products) {
      if (products == null) {
        this._productsLoading = false;
        this.notifyListeners();
        return;
      }

      this._products =
          products.map<Product>((e) => Product.fromJson(e)).toList();

      this._productsLoading = false;
      this.notifyListeners();
    });
  }

  ///
  /// Set selected product index
  ///
  void setSelectedProduct(var index) {
    this._selectedProduct = index;
  }

  ///
  /// Restore the stored version of order
  ///
  Future<void> restoreStoredOrder() async {
    this._orderRestoring = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getKeys().contains('_order')) {
      try {
        final String orderString = prefs.getString('_order');
        final Map<String, dynamic> orderData = jsonDecode(orderString);
        final Order order = Order.fromJson(orderData, this);

        this._order = order;
      } catch (e) {
        this._order = Order(client: OrderClient.empty, products: []);
      }
    } else {
      this._order = Order(client: OrderClient.empty, products: []);
    }

    this._orderRestoring = false;
    notifyListeners();
  }

  ///
  /// Persist the active version of order
  ///
  Future<void> persistOrder() async {
    final prefs = await SharedPreferences.getInstance();

    final orderString = jsonEncode(this._order.toJson(false));
    return prefs.setString('_order', orderString).then((ok) {
      if (!ok) {
        throw new Exception("Failed to save on Shared Prefrences");
      }
    });
  }

  ///
  /// Post order
  ///
  Future<bool> postOrder(BuildContext context) {
    this._orderUploading = true;
    this.notifyListeners();

    final base64 =
        base64Encode(utf8.encode(jsonEncode(this._order.toJson(true))));

    return Http.get(context, "${DotEnv().env['postOrderUrl']}?o=$base64")
        .then((dynamic response) {
      print("post order => $response");
      this._orderUploading = false;

      if (response == null) {
        this.notifyListeners();
        return false;
      }

      this.clearOrder();
      this.notifyListeners();
      return true;
    });
  }

  ///
  /// Insert the item into list of order's products
  ///
  Future<bool> addProductToOrder(OrderProduct item) async {
    if (this._order == null) {
      throw Exception("OrderDoesnotRestored");
    }
    if (item == null || item.product == null) {
      return false;
    }
    this._order.products.add(item);
    await this.persistOrder();
    notifyListeners();
    return true;
  }

  Future<bool> addProductToOrderById(int productId, int quantity) async {
    if (this._order == null) {
      throw Exception("OrderDoesnotRestored");
    }
    if (productId == null || quantity == null) {
      return false;
    }

    final product = this._products.firstWhere((e) => e.id == productId);
    if (product == null || !product.available) {
      return false;
    }

    return this.addProductToOrder(new OrderProduct(
      product: product,
      quantity: quantity,
    ));
  }

  bool hasOrderItem(int productId) {
    if (productId == null || this._order == null) {
      return false;
    }

    return this._order.products.any((e) => e.product.id == productId);
  }

  ///
  /// Update quantity of a specific orders' product
  ///
  Future<void> setOrderProductQuantity(int productId, int quantity) async {
    final item =
        this._order.products.firstWhere((e) => e.product.id == productId);
    item?.quantity = quantity;
    await this.persistOrder();
    notifyListeners();
  }

  Future<void> removeProductFromOrder(int productId) async {
    if (productId == null) {
      throw new Exception('Product id not found');
    }

    this._order.products.removeWhere((p) => p.product.id == productId);
    await this.persistOrder();
    notifyListeners();
  }

  ///
  /// setOrderClient
  ///
  Future<void> setOrderClientFromInstance(OrderClient client) async {
    this._order.client = client;
    await this.persistOrder();
    notifyListeners();
  }

  ///
  /// setOrderClient
  ///
  Future<void> setOrderClientDetails(
      {String name,
      String phone,
      int provinceId,
      String address,
      String notes,
      String userId,
      bool notify = true}) async {
    if (this._order == null || this._order.client == null) {
      throw new Exception("OrderDoesnotRestored");
    }

    if (name != null) {
      this._order.client.name = name;
    }

    if (phone != null) {
      this._order.client.phone = phone;
    }

    if (provinceId != null) {
      print(provinceId);
      final province =
          this.provinces.firstWhere((e) => e.id == provinceId, orElse: null);
      this._order.client.province = province;
    }

    if (address != null) {
      this._order.client.address = address;
    }

    if (notes != null) {
      this._order.client.notes = notes;
    }

    if (userId != null) {
      this._order.client.userId = userId;
    }

    print(this._order.client.toJson(false));
    await this.persistOrder();
    if (notify) {
      notifyListeners();
    }
  }

  OrderClient get client {
    if (this._order == null || this._order.client == null) {
      throw new Exception("OrderDoesnotRestored");
    }
    return this._order.client;
  }

  ///
  /// Set order promo code after verify it's activation
  ///
  Future<bool> setPromoCode(BuildContext context, String promoCode) async {
    final String url =
        DotEnv().env['checkPromoCodeUrl'].replaceAll(':code', promoCode);
    return Http.get(context, url).then((response) async {
      if (response == null) {
        this._order.promoCode = null;
        notifyListeners();
        return false;
      }
      final code = OrderPromoCode.fromJson(response as Map<String, dynamic>);
      _order.promoCode = code;
      _order.promoCode.valid = true;

      await this.persistOrder();
      notifyListeners();
      return true;
    });
  }

  ///
  /// Get order promo code
  ///
  OrderPromoCode get orderPromoCode {
    if (this._order == null || this._order.promoCode == null) {
      throw new Exception("OrderDoesnotRestored");
    }
    return this._order.promoCode;
  }

  Future<void> clearOrder() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('_order');
    this._order = null;

    this.restoreStoredOrder();
  }

  ///
  /// Count number of items in Current Order
  ///
  String get orderItemsCount {
    if (this._order == null || this._order.products == null) {
      throw new Exception("OrderDoesnotRestored");
    }

    if (this.order.products.length == 0) {
      return 0.toString();
    }

    return order.products
        .map((e) => e.quantity)
        .toList()
        .reduce((value, e) => value + e)
        .toString();
  }
}
