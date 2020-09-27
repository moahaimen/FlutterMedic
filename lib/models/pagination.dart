import 'package:drugStore/utils/http.dart';
import 'package:flutter/material.dart';

enum PaginationStatus { Null, Loading, Ready }

class Pagination<TModel> {
  List<TModel> data;

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
  TModel Function(dynamic e) callback;
  final void Function() notifier;

  Pagination(this.notifier, {@required this.path, @required this.callback})
      : this.status = PaginationStatus.Null;

  Future<void> fetch(BuildContext context,
      {String path,
      TModel Function(dynamic e) cb,
      bool notify = true,
      bool status = true}) async {
//    assert(context != null);
    assert(this.path != null || path != null);
    assert(this.callback != null || cb != null);

    if (cb != null) {
      this.callback = cb;
    }

    if (path != null) {
      this.path = path;
    }

    if (status) this.status = PaginationStatus.Loading;
    if (notify) this.notifier();

    final response = await Http.get<dynamic>(context, this.path);

    if (response == null) {
      throw 'Response was null';
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

    if (this.data == null) {
      this.data = new List();
    }
    List.from(response['data']).forEach((e) => this.data.add(this.callback(e)));

    if (status) this.status = PaginationStatus.Ready;
    this.notifier();
  }
}

class SelectablePagination<TModel> extends Pagination<TModel> {
  int index;

  SelectablePagination(void Function() notifier,
      {@required String path, @required TModel Function(dynamic e) cb})
      : super(notifier, path: path, callback: cb);

  TModel get selected => this.data != null &&
          this.index != null &&
          this.data.length > this.index &&
          this.index >= 0
      ? this.data[index]
      : null;

  void select(TModel entity) {
    assert(entity != null);
    assert(this.status == PaginationStatus.Ready);

    final int i = this.data.indexOf(entity);
    assert(i >= 0 && i < this.data.length);

    this.index = i;
    notifier();
  }

  void noSelect() {
    this.index = null;
    notifier();
  }
}