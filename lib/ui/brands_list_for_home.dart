import 'dart:async';

import 'package:drugStore/components/brand_list_home_item.dart';
import 'package:drugStore/models/brand.dart';
import 'package:flutter/material.dart';

class BrandsListForHome extends StatefulWidget {
  final List<Brand> brands;

  BrandsListForHome({@required this.brands});

  @override
  State<StatefulWidget> createState() => _BrandsListForHomeState();
}

class _BrandsListForHomeState extends State<BrandsListForHome> {
  static final double _width = 132.0;
  static final int _roundDuration = 2;
  static final int _animteDuration = 777;

  int _index;
  ScrollController _controller;

  Timer _timer;

  _BrandsListForHomeState() {
    _index = 0;
    _controller = new ScrollController();
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
    return ListView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: widget.brands
          .map<Widget>((e) => BrandListHomeItem(brand: e, width: _width))
          .toList(),
    );
  }

  void _start() {
    _timer = Timer.periodic(
      Duration(seconds: _roundDuration),
      (Timer timer) => _animateToNext(),
    );
  }

  void _cancel() => _timer.cancel();

  Future<void> _animateToNext() async {
    final int count = widget.brands != null && widget.brands.length > 0
        ? widget.brands.length
        : 1;
    final double offset = _width * (_index % count) + 15;
    await _controller.animateTo(
      offset,
      duration: Duration(milliseconds: _animteDuration),
      curve: Curves.easeInOut,
    );
    _index++;
  }
}
