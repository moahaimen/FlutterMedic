import 'package:flutter/material.dart';

import '../localization/app_translation.dart';
import 'attachment.dart';
import 'brand.dart';
import 'category.dart';

class Product {
  final int id;
  final String enName;
  final String arName;
  final String enDescription;
  final String arDescription;
  final num price;
  final num previousPrice;
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
      this.previousPrice,
      this.dateOfPriceChange,
      this.attachments,
      this.brand,
      this.category,
      this.isMain,
      this.available);

  Product.json(Map<String, dynamic> data, double exchange)
      : this(
            data['id'],
            data['en_name'],
            data['ar_name'],
            data['en_description'],
            data['ar_description'],
            data['price']['value'] * exchange,
            data['price']['is_discount']
                ? data['price']['previous']['value'] * exchange
                : null,
            DateTime.parse(data['price']['updated_at']),
            Attachment.toList(data['attachments'] as List),
            Brand.fromJson(data['brand']),
            Category.fromJson(data['category']),
            data['is_main'],
            data['available']);

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
      return null;
    }
    return attachments.firstWhere((e) => e.type == AttachmentType.Image);
  }

  bool get isDiscount {
    return this.previousPrice != null;
  }
}
