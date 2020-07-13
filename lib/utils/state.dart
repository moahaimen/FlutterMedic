import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/models/order_product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:convert' as json;

import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'http.dart';

class StateModel extends Model {
  //
  // Brands
  //
  bool _brandsLoading;
  List<Brand> _brands;

  bool get brandsLoading => this._brandsLoading;

  List<Brand> get brands => List.from(this._brands);

  List<Brand> get topBrands => List.from(this._brands.take(5));

  //
  // Categories
  //
  bool _categoriesLoading;
  List<Category> _categories;

  bool get categoriesLoading => this._categoriesLoading;

  List<Category> get categories => List.from(this._categories);

  List<Category> get topCategories => List.from(this.categories.take(5));

  //
  // Products
  //
  bool _productsLoading;
  var _selectedProduct;
  List<Product> _products;

  bool get productsLoading => this._productsLoading;

  Product get selectedProduct =>
      this._products.firstWhere((element) => element.id == _selectedProduct);

  Product get selectedOrFirstProduct {
    if (_products == null || _products.length == 0) return null;

    final i = _products.firstWhere((element) => element.id == _selectedProduct);

    if (i != null) return i;
    return _products.first;
  }

  List<Product> get products => List.from(this._products);

  List<Product> get mainProducts =>
      List.from(this._products.where((element) => element.isMain));

  ///
  /// Cart Management
  ///
  bool _orderUploading;
  Order _order;

  bool get orderUploading => this._orderUploading;

  Order get order => this._order;

  StateModel() {
    _initializeModelData();
  }

  void _initializeModelData() {
    this._brands = [];
    this._categories = [];
    this._products = [];

    this.fetchModelData();
    this.restoreStoredOrder();
  }

  void fetchModelData() {
    this.fetchBrands();
    this.fetchCategories();
    this.fetchProducts();
  }

  ///
  /// Fetch list of categories
  ///
  Future<void> fetchCategories() {
    this._categoriesLoading = true;
    this.notifyListeners();

    return Http.get(DotEnv().env['fetchCategoriesUrl'])
        .then((dynamic categories) {
      this._categories = categories
          .map<Category>((e) => new Category(e['name'], e['description']))
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
  ///
  ///
  Future<void> restoreStoredOrder() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.hasString('_order')) {
      final String orderString = prefs.getString('_order');
      final Map<String, dynamic> orderData = json.jsonDecode(orderString);
      final Order order = Order.fromJson(orderData);
    }
  }

  ///
  /// Upload order
  ///
  Future<bool> uploadOrder() {
    this._orderUploading = true;
    this.notifyListeners();

    Map<String, dynamic> data = new Map();
    Map<String, dynamic> clientData = new Map();
    Map<String, dynamic> productsData = new Map();

    clientData['name'] = this._order.client.name;
    clientData['email'] = this._order.client.email;
    clientData['phone'] = this._order.client.phone;
    clientData['province'] = this._order.client.province;
    clientData['address'] = this._order.client.address;
    clientData['note'] = this._order.client.note;
    clientData['userId'] = this._order.client.userId;

    this._order.products.forEach((element) {
      productsData['product_id'] = element.product.id;
      productsData['quantity'] = element.quantity;
    });

    data['promo_code'] = this._order.promoCode;
    data['client'] = clientData;
    data['products'] = productsData;

    print(json.jsonEncode(data));

    return Http.post(DotEnv().env['postOrderUrl'], data)
        .then((dynamic response) {
      this._orderUploading = false;
      this.notifyListeners();

      return response != null;
    });
  }

  void addOrderProductItem(OrderProduct item) {
    if (item == null || item.product == null) {
      return;
    }
    if (this._order == null) {
      this._order = new Order(client: null, products: []);
    }
    this._order.products.add(item);
    notifyListeners();
  }

  void setOrderProducts(List<OrderProduct> products) {
    this._order.products = products;
  }

  void setOrderProduct(int productId, int quantity) {
    final item = this
        ._order
        .products
        .firstWhere((element) => element.product.id == productId);
    item.quantity = quantity;
  }

  void setOrderClient(OrderClient client) {
    this._order.client = client;
  }

  void setOrderPromoCode(String promoCode) {
    this._order.promoCode = promoCode;
  }
}
