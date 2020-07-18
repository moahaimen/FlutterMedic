import 'dart:convert';

import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/models/order_product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'http.dart';

class StateModel extends Model {
  //
  // Brands
  //
  bool _brandsLoading = false;
  List<Brand> _brands;

  bool get brandsLoading => this._brandsLoading;

  List<Brand> get brands => List.from(this._brands);

  List<Brand> get topBrands => List.from(this._brands.take(5));

  //
  // Categories
  //
  bool _categoriesLoading = false;
  List<Category> _categories;

  bool get categoriesLoading => this._categoriesLoading;

  List<Category> get categories => List.from(this._categories);

  List<Category> get topCategories => List.from(this.categories.take(5));

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
      List.from(this._products.where((e) => e.isMain));

  ///
  /// Cart Management
  ///
  bool _orderRestoring = true;
  bool _orderUploading = false;
  Order _order;

  bool get orderUploading => this._orderUploading;

  bool get orderRestoring => this._orderRestoring;

  Order get order => this._order;

  StateModel() {
    _initializeModelData();
  }

  void _initializeModelData() {
    this._brands = [];
    this._categories = [];
    this._products = [];

    this.fetchModelData();
  }

  void fetchModelData() {
    this.fetchBrands();
    this.fetchCategories();
    this.fetchProducts().then((value) => this.restoreStoredOrder());
  }

  ///
  /// Fetch list of categories
  ///
  Future<void> fetchCategories() {
    this._categoriesLoading = true;
    this.notifyListeners();

    return Http.get(DotEnv().env['fetchCategoriesUrl'])
        .then((dynamic categories) {
      if (categories == null) {
        this._categoriesLoading = false;
        this.notifyListeners();
        return;
      }

      this._categories = categories
          .map<Category>((e) =>
      new Category(
        e['name'],
        e['description'],
        e['icon'],
        e['color'],
      ))
          .toList();

      this._categoriesLoading = false;
      this.notifyListeners();
    });
  }

  ///
  /// Fetch list of brands
  ///
  Future<void> fetchBrands() {
    this._brandsLoading = true;
    this.notifyListeners();

    return Http.get(DotEnv().env['fetchBrandsUrl']).then((dynamic result) {
      if (result == null) {
        this._brandsLoading = false;
        this.notifyListeners();
        return;
      }
      this._brands = result
          .map<Brand>((e) => new Brand(e['name'], e['attachment']['url']))
          .toList();

      this._brandsLoading = false;
      this.notifyListeners();
    });
  }

  ///
  /// Fetch list of products
  ///
  Future<void> fetchProducts() {
    this._productsLoading = true;
    this.notifyListeners();

    return Http.get(DotEnv().env['fetchProductsUrl']).then((dynamic products) {
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
      final String orderString = prefs.getString('_order');
      final Map<String, dynamic> orderData = jsonDecode(orderString);
      final Order order = Order.fromJson(orderData, this);

      this._order = order;
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

    final orderString = jsonEncode(this._order.toJson());
    return prefs.setString('_order', orderString);
  }

  ///
  /// Post order
  ///
  Future<bool> postOrder() {
    this._orderUploading = true;
    this.notifyListeners();

    final base64 = base64Encode(utf8.encode(jsonEncode(this._order.toJson())));

    return Http.get("${DotEnv().env['postOrderUrl']}?o=$base64")
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
    if (product == null) {
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
    this._order.products.removeWhere((e) => e.product.id == productId);
    await this.persistOrder();
    notifyListeners();
  }

  Future<void> setOrderClient(OrderClient client) async {
    this._order.client = client;
    await this.persistOrder();
    notifyListeners();
  }

  OrderClient get client {
    if (this._order == null || this._order.client == null) {
      throw new Exception("OrderDoesnotRestored");
    }
    return this._order.client;
  }

  Future<void> setOrderPromoCode(String promoCode) async {
    this._order.promoCode = promoCode;
    await this.persistOrder();
    notifyListeners();
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

  ///
  /// Verify promo code activation
  ///
  Future<Map<String, dynamic>> verifyPromoCodeActivation(
      String promoCode) async {
    final String url =
    DotEnv().env['checkPromoCodeUrl'].replaceAll(':code', promoCode);
    return Http.get(url).then(
          (response) {
        if (response != null) {
          return response as Map<String, dynamic>;
        }
        return null;
      },
    );
  }
}
