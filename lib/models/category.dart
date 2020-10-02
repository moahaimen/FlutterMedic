import 'package:flutter/material.dart';

import '../localization/app_translation.dart';
import 'category_icon.dart';

class Category {
  static Category fromJson(Map<String, dynamic> data) {
    return new Category(
      data['id'],
      data['en_name'],
      data['ar_name'],
      data['en_description'],
      data['ar_description'],
      new CategoryIcon(data['icon']),
    );
  }

  final int id;
  final String enName;
  final String arName;
  final String enDescription;
  final String arDescription;
  final CategoryIcon icon;

  Category(this.id, this.enName, this.arName, this.enDescription,
      this.arDescription, this.icon);

  Category.from(Category source)
      : this.id = source.id,
        this.enName = source.enName,
        this.arName = source.arName,
        this.enDescription = source.enDescription,
        this.arDescription = source.arDescription,
        this.icon = source.icon;

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

  String getTitle(BuildContext context) {
    final name = getName(context);
    return name.length >= 12 ? '${name.substring(0, 12)}...' : name;
  }
}
