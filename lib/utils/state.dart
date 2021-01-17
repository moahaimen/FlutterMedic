import 'dart:convert';

import 'package:drugStore/constants/envirnoment.dart';
import 'package:drugStore/localization/application.dart';
import 'package:drugStore/models/order/order.dart';
import 'package:drugStore/models/order/order_client.dart';
import 'package:drugStore/models/order/order_product.dart';
import 'package:drugStore/models/order/promo_code.dart';
import 'package:drugStore/models/province.dart';
import 'package:drugStore/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'http.dart';

class StateModel extends Model {
  //
  // Auth user
  //
  bool _userLoading = false;
  User _user;

  bool get userLoading => this._userLoading;

  User get user => _user;

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
    'notifications': true,
    'exchange': 'IQD'
  };
  Map<String, dynamic> _settings;

  bool get settingsLoading => this._settingsLoading;

  Map<String, dynamic> get settings => Map.from(_settings);

  String get currency => _settings['exchange'] ?? 'IQD';

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
  // Exchange
  //
  bool _exchangeLoading = false;
  double _exchange;

  bool get exchangeLoading => _exchangeLoading;

  double get exchange => currency == 'USD' ? 1 : _exchange;

  //
  // Products
  //
  bool _productsLoading = false;
  var _selectedProduct;
  List<Product> _products;
  int take = 1;

  void increaseTake() {
    take++;
    notifyListeners();
  }

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

  Stream<String> messages;

  StateModel() {
    _initializeModelData();
  }

  void _initializeModelData() {
    this._brands = [];
    this._categories = [];
    this._products = [];
    this._provinces = [];

    this.messages = new Stream.fromFutures([
      this.restoreStoredUser(),
      this.loadSettings(),
      this.fetchLatestExchange(),
      this.fetchBrands(),
      this.fetchCategories(),
      this.fetchProducts().then((e) => this.restoreStoredOrder()),
      this.fetchContactUs(),
      this.fetchProvinces(),
    ]);
    // this.fetchModelData();
  }

  Future<void> fetchModelData() async {
    await this.restoreStoredUser();
    await this.loadSettings();
    await this.fetchLatestExchange();

    await this.fetchBrands();
    await this.fetchCategories();
    //
    await this.fetchProducts();
    await this.restoreStoredOrder();
    //
    await this.fetchContactUs();
    await this.fetchProvinces();
  }

  ///
  /// Fetch contact us information
  ///
  Future<String> fetchContactUs() async {
    _contactUsLoading = true;
    notifyListeners();

    Result<dynamic> response =
        await Http.get(Environment.fetchContactUsUrl, new Map());

    if (response == null || response.error != null) {
      _contactUsLoading = false;
      notifyListeners();
      return 'Failed to fetch contact information';
    }
    final List<dynamic> data = response.result['data'] as List<dynamic>;
    _contactUs = new Map();

    data.forEach((e) {
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
    return 'Contact information fetched successfully';
  }

  ///
  /// Fetch provinces list
  ///
  Future<String> fetchProvinces() async {
    _provincesLoading = true;
    notifyListeners();

    try {
      final Result<dynamic> response = await Http.get(
          Environment.fetchProvincesUrl, new Map<String, String>());

      if (response == null || response.error != null) {
        this._provincesLoading = false;
        this.notifyListeners();
        return 'Failed to fetch provinces';
      }

      this._provinces = response.result['data']
          .map<Province>((e) => Province.json(e, exchange))
          .toList();
    } catch (e) {
      _provinces = [];
      print('FETCH PROVINCES | $e');
    }

    this._provincesLoading = false;
    this.notifyListeners();
    return 'Provinces fetched successfully';
  }

  ///
  /// Fetch current exchange
  ///
  Future<String> fetchLatestExchange() {
    _exchangeLoading = true;
    notifyListeners();

    return Http.get(Environment.fetchExchangeUrl, new Map<String, String>())
        .then((Result exchange) {
      if (exchange != null && exchange.error == null) {
        this._exchange = exchange.result['value'].toDouble();
      }
      this._exchangeLoading = false;
      this.notifyListeners();
      return 'Loading latest exchange data';
    });
  }

  ///
  /// Fetch list of categories
  ///
  Future<String> fetchCategories() {
    this._categoriesLoading = true;
    this.notifyListeners();

    return Http.get(Environment.fetchCategoriesUrl, new Map<String, String>())
        .then((Result categories) {
      if (categories == null || categories.error != null) {
        this._categoriesLoading = false;
        this.notifyListeners();
        return 'Failed to fetch categories list';
      }

      this._categories = categories.result['data']
          .map<Category>((e) => Category.fromJson(e))
          .toList();

      this._categoriesLoading = false;
      this.notifyListeners();
      return 'Categories list fetched successfully';
    });
  }

  ///
  /// Load settings from preferences
  ///
  Future<String> loadSettings() {
    this._settingsLoading = true;
    this.notifyListeners();

    return SharedPreferences.getInstance().then((prefs) {
      this._settings = prefs.getString('_settings') != null
          ? json.decode(prefs.getString('_settings'))
          : _defaultSettings;

      this._settingsLoading = false;
      this.notifyListeners();
      return 'Settings loaded successfully';
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

  Future<void> setSettingsItem(String key, dynamic value) {
    _settings.addAll({key: value});
    return setSettings(_settings);
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
  Future<String> fetchBrands() {
    this._brandsLoading = true;
    this.notifyListeners();

    return Http.get(Environment.fetchBrandsUrl, new Map<String, String>())
        .then((Result result) {
      if (result == null || result.error != null) {
        this._brandsLoading = false;
        this.notifyListeners();
        return 'Brands List Loading Failed';
      }
      this._brands =
          result.result['data'].map<Brand>((e) => Brand.fromJson(e)).toList();

      this._brandsLoading = false;
      this.notifyListeners();
      return 'Brands list fetched successfully';
    });
  }

  ///
  /// Fetch list of products
  ///
  Future<String> fetchProducts() {
    this._productsLoading = true;
    this.notifyListeners();

    return Http.get(Environment.fetchProductsUrl, new Map<String, String>())
        .then((Result products) {
      if (products == null || products.error != null) {
        this._productsLoading = false;
        this.notifyListeners();
        return 'Failed to fetch products';
      }
      _products = (products.result['data'] as List)
          .map((p) => Product.json(p, exchange))
          .toList();

      this._productsLoading = false;
      this.notifyListeners();
      return 'Products fetched successfully';
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
  Future<String> restoreStoredOrder() async {
    this._orderRestoring = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getKeys().contains('_order')) {
      try {
        final String orderString = prefs.getString('_order');
        final Map<String, dynamic> orderData = jsonDecode(orderString);

        print(orderData);
        final Order order = Order.json(orderData, this);
        this._order = order;
      } catch (e) {
        print('asdasdasdasd $e');
        this._order = Order.empty();
      }
    } else {
      print('asdasdasdasd');
      this._order = Order.empty();
    }

    this._orderRestoring = false;
    notifyListeners();
    return 'Cart restored successfully';
  }

  ///
  /// Persist the active version of order
  ///
  Future<void> persistOrder() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final orderString = jsonEncode(this._order.toJson(false));
      return prefs.setString('_order', orderString).then((ok) {
        if (!ok) {
          throw new Exception("Failed to save on Shared Prefrences");
        }
      });
    } catch (e) {
      print(e);
    }
  }

  ///
  /// Post order
  ///
  Future<bool> postOrder() async {
    this._orderUploading = true;
    this.notifyListeners();

    final Result<dynamic> response = this._user != null
        ? await Http.post(Environment.userOrdersUrl, this._order.toJson(true),
            {'Authorization': 'Bearer ${user.token}'})
        : await Http.post(Environment.postOrderUrl, this._order.toJson(true),
            new Map<String, String>());

    this._orderUploading = false;
    if (response == null || response.error != null) {
      this.notifyListeners();
      return false;
    }

    this.clearOrder();
    this.notifyListeners();
    return true;
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

    return this.addProductToOrder(new OrderProduct(product, quantity));
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
  Future<bool> setPromoCode(String promoCode) async {
    final String url =
        Environment.checkPromoCodeUrl.replaceAll(':code', promoCode);
    return Http.get(url, new Map<String, String>()).then((response) async {
      if (response == null || response.error != null) {
        this._order.promoCode = null;
        notifyListeners();
        return false;
      }
      final code = OrderPromoCode.json(response as Map<String, dynamic>);
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

  Future<List<Order>> fetchUserOrders() async {
    if (this._user == null) {
      await this.restoreStoredUser();
    }
    final result = await Http.get(
        Environment.userOrdersUrl, {'Authorization': 'Bearer ${user.token}'});

    if (result == null || result.error != null) {
      return [];
    }
    return result.result
        .map<Order>((e) => Order.full(_user, e, exchange))
        .toList();
  }

  ///
  ///
  ///
  Future<bool> loginUser(Map<String, dynamic> loginData) async {
    this._userLoading = true;
    this._user = null;
    this.notifyListeners();

    final result = await Http.post(
        Environment.loginUrl, loginData, new Map<String, String>());

    if (result == null || result.error != null) {
      this._userLoading = false;
      this.notifyListeners();
      return false;
    }

    this._user = new User.json(result.result['user'], result.result['token']);
    await this.saveUser();
    this._userLoading = false;
    this.notifyListeners();
    return true;
  }

  Future<dynamic> registerUser(Map<String, dynamic> registerData) async {
    this._userLoading = true;
    this._user = null;
    this.notifyListeners();

    // Client
    registerData.addAll({
      'role_id': 4,
    });
    final result = await Http.post(
        Environment.registerUrl, registerData, new Map<String, String>());

    if (result == null || result.error != null) {
      this._userLoading = false;
      this.notifyListeners();
      return result.error;
    }

    this._user = new User.json(result.result['user'], result.result['token']);
    await this.saveUser();
    this._userLoading = false;
    this.notifyListeners();
    return this.user;
  }

  ///
  ///
  ///
  Future<String> restoreStoredUser() async {
    this._userLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    if (prefs.getKeys().containsAll(['_user', '_token'])) {
      try {
        final String token = prefs.getString('_token');

        final String userJson = prefs.getString('_user');
        final Map<String, dynamic> userData = jsonDecode(userJson);
        final User user = User.json(userData, token);

        this._user = user;
      } catch (e) {
        this._user = null;
      }
    }

    this._userLoading = false;
    notifyListeners();
    return 'Finishing user restoring';
  }

  ///
  ///
  ///
  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (this._user == null) {
      await prefs.remove('_user');
      await prefs.remove('_token');
    } else {
      final ok1 =
          await prefs.setString('_user', jsonEncode(this._user.toJson()));
      final ok2 = await prefs.setString('_token', this._user.token);

      if (!ok1 || !ok2) {
        throw new Exception("Shared Prefecnces Save Exception");
      }
    }
  }

  Future<bool> logout() async {
    this._userLoading = true;
    this.notifyListeners();

    final Result<dynamic> result = await Http.post(Environment.logoutUrl,
        this.user.toJson(), {'Authorization': 'Bearer ${user.token}'});

    if (result == null || result.error != null) {
      this._userLoading = false;
      this.notifyListeners();
      return false;
    }
    this._userLoading = false;
    this._user = null;
    await this.saveUser();
    this.notifyListeners();
    return true;
  }

  Future<bool> updateUser(Map<String, dynamic> updateData) async {
    final Result<dynamic> response = await Http.put(
        Environment.updateUserDetailsUrl,
        updateData,
        {'Authorization': 'Bearer ${user.token}'});

    if (response == null || response.error != null) {
      return false;
    }

    this._user = new User.json(response.result, this._user.token);
    await this.saveUser();
    this.notifyListeners();
    return true;
  }

  Future<User> refreshUser() async {
    final dynamic result = await Http.get(
        Environment.userDetailsUrl, {'Authorization': 'Bearer ${user.token}'});

    if (result == null || result.error != null) {
      return null;
    }
    this._user = new User.json(result, this._user.token);
    await this.saveUser();
    this.notifyListeners();
    return user;
  }
}
