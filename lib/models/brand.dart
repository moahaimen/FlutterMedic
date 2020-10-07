import 'package:drugStore/models/pagination.dart';
import 'package:flutter/material.dart';

import '../localization/app_translation.dart';

class Brand extends IModel {
  static Brand fromJson(Map<String, dynamic> data) {
    final String photoUrl =
        data['attachment'] != null ? data['attachment']['url'] ?? '' : '';
    return new Brand(data['id'], data['en_name'], data['ar_name'], photoUrl);
  }

  final int id;
  final String enName;
  final String arName;
  final String photoUrl;

  Brand(this.id, this.enName, this.arName, this.photoUrl);

  Brand.from(Brand source)
      : this.id = source.id,
        this.enName = source.enName,
        this.arName = source.arName,
        this.photoUrl = source.photoUrl;

  String getName(BuildContext context) {
    return AppTranslations.of(context).locale.languageCode == "en"
        ? enName
        : arName;
  }

  String getTitle(BuildContext context) {
    final name = getName(context);
    return name.length >= 12 ? '${name.substring(0, 12)}...' : name;
  }

  @override
  int get identifier => this.id;

  @override
  bool verify(Map<String, dynamic> filter) {
    if (filter == null || filter.isEmpty) {
      return true;
    }

    if (filter.containsKey('name')) {
      final name = filter['name'];
      return this.enName.contains(name) || this.arName.contains(name);
    }
    print('false $filter');
    return false;
  }
}
