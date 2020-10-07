import 'package:drugStore/utils/http.dart';
import 'package:flutter/material.dart';

enum PaginationStatus { Null, Loading, Ready }

abstract class IModel {
  int get identifier;
  bool verify(Map<String, dynamic> filter);
}

class Pagination<TModel extends IModel> {
  List<TModel> _data;

  int total;
  int perPage;

  int currentPage;
  int from;
  int to;

  String path;
  String firstPageUrl;
  String prevPageUrl;
  String nextPageUrl;
  String lastPageUrl;
  int lastPage;

  PaginationStatus status;
  void Function() notifier;
  TModel Function(Map<String, dynamic>) parse;

  Map<String, dynamic> filter;

  List<TModel> get data =>
      _data == null ? [] : List.from(_data.where((e) => e.verify(filter)));

  void initialize(
    void Function() notifier,
    TModel Function(Map<String, dynamic>) parse,
    String path,
  ) {
    this._data = new List<TModel>();

    this.notifier = notifier;
    this.parse = parse;
    this.path = path;

    this.status = PaginationStatus.Null;
  }

  Future<void> load(BuildContext context,
      {int page,
      bool notify,
      bool status,
      bool dialog,
      Map<String, dynamic> filter}) async {
    assert(context != null);

    if (notify == null) {
      notify = true;
    }
    if (status == null) {
      status = true;
    }

    if (dialog == null) {
      dialog = false;
    }

    if (page == null) {
      if (page == this.currentPage) {
        this._data.clear();
      }
      page = this.currentPage;
    }
    if (filter != null) {
      this.filter = filter;
    }
    if (this.filter == null) {
      this.filter = new Map();
    }

    // Start load the data
    //
    if (status) {
      this.status = PaginationStatus.Loading;
      if (dialog) {
        this._showLoadingDialog(context);
      }
    }

    if (notify) {
      this.notifier();
    }

    final response = await Http.get<dynamic>(context, this.path,
        params: {...this.filter, 'page': page});

    if (response == null) {
      throw new Exception('the response is null or bad request');
    }

    this.total = response['total'];
    this.perPage = response['per_page'];
    this.currentPage = response['current_page'];
    this.from = response['from'];
    this.to = response['to'];
    this.path = response['path'];
    this.firstPageUrl = response['first_page_url'];
    this.prevPageUrl = response['prev_page_url'];
    this.nextPageUrl = response['next_page_url'];
    this.lastPageUrl = response['last_page_url'];
    this.lastPage = response['last_page'];

    List.from(response['data']).forEach((e) => this._data.add(this.parse(e)));

    if (status) {
      if (dialog) {
        Navigator.of(context).pop(context);
      }
      this.status = PaginationStatus.Ready;
    }
    this.notifier();
  }

  Future<void> loadNext(BuildContext context,
      {Map<String, dynamic> filter,
      bool notify,
      bool status,
      bool dialog}) async {
    await this.load(context,
        page: currentPage + 1,
        filter: filter,
        status: status,
        notify: notify,
        dialog: dialog);
  }

  bool get hasNext => this.currentPage < this.lastPage;

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void useFilter(String key, dynamic value) {
    if (this.filter == null) {
      this.filter = new Map();
    }
    this.filter[key] = value;
    print(this.filter);
    this.notifier();
  }

  void clearFilter() {
    this.filter = null;
    this.notifier();
  }

  void checkStatus() {
    if (this._data != null) {
      this.filter = null;
      this.status = PaginationStatus.Ready;
    } else {
      this.status = PaginationStatus.Null;
    }
  }
}

class SelectablePagination<TModel extends IModel> extends Pagination<TModel> {
  int _id;

  TModel get selected => this._data != null && this._id != null
      ? this._data.firstWhere((p) => p.identifier == _id)
      : null;

  void select(TModel entity) {
    assert(entity != null);
    assert(this.status == PaginationStatus.Ready);

    final int i = this._data.indexOf(entity);
    assert(i >= 0 && i < this._data.length);

    this._id = entity.identifier;
    notifier();
  }

  void reset() {
    this._id = null;
    notifier();
  }
}
