import 'package:drugStore/models/order.dart';
import 'package:drugStore/models/order_client.dart';
import 'package:drugStore/models/order_product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';

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
  /// Restore the stored version of order
  ///
  Future<void> restoreStoredOrder() async {
//    final prefs = await SharedPreferences.getInstance();

//    if (prefs.containsKey('_order')) {
//      final String orderString = prefs.getString('_order');
//      final Map<String, dynamic> orderData = jsonDecode(orderString);
//      final Order order = Order.fromJson(orderData, this);
//
//      this._order = order;
//      print(this._order);
//    }
  }

  ///
  /// Persist the active version of order
  ///
  Future<void> persistOrder() async {
//    final prefs = await SharedPreferences.getInstance();

//    final orderString = jsonEncode(this._order.toJson());
//    prefs.setString('_order', orderString);
  }

  ///
  /// Post order
  ///
  Future<bool> postOrder() {
    this._orderUploading = true;
    this.notifyListeners();

    return Http.post(DotEnv().env['postOrderUrl'], this._order.toJson())
        .then((dynamic response) {
      print("post order => $response");

      this._orderUploading = false;

      this.clearOrder();
      this.notifyListeners();
      return response != null;
    });
  }

  ///
  /// Insert the item into list of order's products
  ///
  Future<void> addProductToOrder(OrderProduct item) async {
    if (item == null || item.product == null) {
      return;
    }
    if (this._order == null) {
      this._order = new Order(client: null, products: []);
    }
    this._order.products.add(item);
    await this.persistOrder();
    notifyListeners();
  }

  Future<bool> addProductToOrderById(int productId, int quantity) async {
    if (productId == null || quantity == null) {
      return false;
    }
    if (this._order == null) {
      this._order = new Order(client: null, products: []);
    }
    final product =
    this._products.firstWhere((element) => element.id == productId);

    if (product == null) {
      return false;
    }
    final item = new OrderProduct(product: product, quantity: quantity);
    this._order.products.add(item);
    await this.persistOrder();
    notifyListeners();
    return true;
  }

  bool hasOrderItem(int productId) {
    if (productId == null || this._order == null) {
      return false;
    }

    return this
        ._order
        .products
        .any((element) => element.product.id == productId);
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
    if (this._order == null) {
      this._order = new Order(client: null, products: []);
    }
    if (this._order.client == null) {
      this._order.client = new OrderClient(
          name: null,
          email: null,
          phone: null,
          province: null,
          address: null);
    }
    return this._order.client;
  }

  Future<void> setOrderPromoCode(String promoCode) async {
    this._order.promoCode = promoCode;
    await this.persistOrder();
    notifyListeners();
  }

  Future<void> clearOrder() async {
//    final prefs = await SharedPreferences.getInstance();
//    prefs.remove('_order');
    this._order = null;
    notifyListeners();
  }

  ///
  /// Count number of items in Current Order
  ///
  String get orderItemsCount {
    if (this._order == null ||
        this._order.products == null ||
        this._order.products.length == 0) {
      return '0';
    }

    return order.products
        .map((e) => e.quantity)
        .toList()
        .reduce((value, element) => value + element)
        .toString();
  }

  ///
  /// Verify promo code activation
  ///
  Future<bool> verifyPromoCodeActivation(String promoCode) async {
    final String url =
    DotEnv().env['checkPromoCodeUrl'].replaceAll(':code', promoCode);
    return Http.get(url).then(
          (response) {
        if (response != null) {
          final data = response as Map<String, dynamic>;
          if (data['id'] != null) {
            return true;
          }
        }
        return false;
      },
    );
  }
}
