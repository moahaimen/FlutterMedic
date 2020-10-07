import 'package:drugStore/models/pagination.dart';
import 'package:flutter/material.dart';

import '../localization/app_translation.dart';
import 'attachment.dart';
import 'brand.dart';
import 'category.dart';

class Product extends IModel {
  static Product fromJson(Map<String, dynamic> data) {
    final brand = Brand.fromJson(data['brand']);
    final category = Category.fromJson(data['category']);

    final List<Attachment> attachments = (data['attachments'] as List<dynamic>)
        .map((e) => new Attachment(
            e['type'] == 0 ? AttachmentType.Image : AttachmentType.Video,
            e['url']))
        .toList();

    return new Product(
        data['id'],
        data['en_name'] ?? '',
        data['ar_name'] ?? '',
        data['en_description'] ?? '',
        data['ar_description'] ?? '',
        data['price']['value'] ?? '',
        data['price']['is_discount']
            ? data['price']['previous']['value']
            : null,
        DateTime.parse(data['price']['updated_at']),
        attachments,
        brand,
        category,
        data['is_main'],
        data['available']);
  }

  final int id;
  final String enName;
  final String arName;
  final String enDescription;
  final String arDescription;
  final num price;
  final num oldPrice;
  final DateTime dateOfPriceChange;
  final Brand brand;
  final Category category;
  final List<Attachment> attachments;
  final bool isMain;
  final bool available;

  Product(
      this.id,
      this.enName,
      this.arName,
      this.enDescription,
      this.arDescription,
      this.price,
      this.oldPrice,
      this.dateOfPriceChange,
      this.attachments,
      this.brand,
      this.category,
      this.isMain,
      this.available);

  String getName(BuildContext context) {
    return AppTranslations.of(context).locale.languageCode == "en"
        ? enName
        : arName;
  }

  String getDescription(BuildContext context) {
    return AppTranslations.of(context).locale.languageCode == "en"
        ? enDescription
        : arDescription;
  }

  String getTitle(BuildContext context, {int length = 12}) {
    final name = getName(context);
    return name.length >= length ? '${name.substring(0, length)}...' : name;
  }

  Attachment get image {
    if (this.attachments == null || this.attachments.length == 0) {
      throw "Product's attachments null or empty";
    }
    final a = attachments.firstWhere((e) => e.type == AttachmentType.Image,
        orElse: () => null);
    if (a == null) {
      throw "Product's attachments list doesn't have any IMAGEs";
    }
    return a;
  }

  bool get isDiscount => this.oldPrice != null;

  @override
  int get identifier => this.id;

  @override
  bool verify(Map<String, dynamic> filter) {
    if (filter == null || filter.isEmpty) {
      return true;
    }

    if (filter.containsKey('name')) {
      final name = filter['name'];
      if (name == null || name == '') {
        return true;
      }
      return this.enName.contains(name) || this.arName.contains(name);
    }

    if (filter.containsKey('category')) {
      final category = filter['category'] as Category;
      if (category == null) {
        return true;
      }
      return this.category.id == category.id;
    }

    if (filter.containsKey('brand')) {
      final brand = filter['brand'] as Brand;
      if (brand == null) {
        return true;
      }
      return this.brand.id == brand.id;
    }

    return false;
  }
}
