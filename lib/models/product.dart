import 'package:flutter/material.dart';

import '../localization/app_translation.dart';
import 'attachment.dart';
import 'brand.dart';
import 'category.dart';

class Product {
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
        DateTime.parse(data['price']['updated_at']),
        attachments,
        brand,
        category,
        data['is_main']);
  }

  final int id;
  final String enName;
  final String arName;
  final String enDescription;
  final String arDescription;
  final num price;
  final DateTime dateOfPriceChange;
  final Brand brand;
  final Category category;
  final List<Attachment> attachments;
  final bool isMain;

  Product(
      this.id,
      this.enName,
      this.arName,
      this.enDescription,
      this.arDescription,
      this.price,
      this.dateOfPriceChange,
      this.attachments,
      this.brand,
      this.category,
      this.isMain);

  String getName(BuildContext context) {
    return AppTranslations
        .of(context)
        .locale
        .languageCode == "en"
        ? enName
        : arName;
  }

  String getDescription(BuildContext context) {
    return AppTranslations
        .of(context)
        .locale
        .languageCode == "en"
        ? enDescription
        : arDescription;
  }

  String getTitle(BuildContext context) {
    final name = getName(context);
    return name.length >= 12 ? '${name.substring(0, 12)}...' : name;
  }

  Attachment get image {
    if (this.attachments == null || this.attachments.length == 0) {
      return null;
    }
    return attachments.firstWhere((e) => e.type == AttachmentType.Image);
  }
}
