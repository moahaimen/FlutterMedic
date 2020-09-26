import 'dart:async';

import 'package:drugStore/components/brand_list_home_item.dart';
import 'package:drugStore/models/brand.dart';
import 'package:drugStore/models/pagination.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BrandsListForHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BrandsListForHomeState();
}

class _BrandsListForHomeState extends State<BrandsListForHome> {
  static final double _width = 132.0;
  static final int _roundDuration = 2;
  static final int _animateDuration = 777;

  List<Brand> _brands;

  int _index;
  ScrollController _controller;

  Timer _timer;

  _BrandsListForHomeState() {
    _index = 0;
    _controller = new ScrollController();
    _brands = [];
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<StateModel>(context);

    assert(model != null);
    assert(model.brands != null);

    final obj = model.brands;

    switch (obj.status) {
      case PaginationStatus.Null:
        obj.fetch(context);
        return Center(child: CircularProgressIndicator());
      case PaginationStatus.Loading:
        return Center(child: CircularProgressIndicator());
      case PaginationStatus.Ready:
        _brands = obj.data;
        return ListView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            children: obj.data
                .map<Widget>((e) => BrandListHomeItem(brand: e, width: _width))
                .toList());
    }
    return null;
  }

  void _start() {
    _timer = Timer.periodic(
      Duration(seconds: _roundDuration),
      (Timer timer) => _animateToNext(),
    );
  }

  void _cancel() => _timer.cancel();

  Future<void> _animateToNext() async {
    try {
      final int count =
      _brands != null && _brands.length > 0 ? _brands.length : 1;
      final double offset = _width * (_index % count) + 15;
      await _controller.animateTo(
        offset,
        duration: Duration(milliseconds: _animateDuration),
        curve: Curves.easeInOut,
      );
      _index++;
    } catch (e) {
      print(e);
    }
  }
}
