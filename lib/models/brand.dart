import 'package:flutter/material.dart';

import '../localization/app_translation.dart';

class Brand {
  static Brand fromJson(Map<String, dynamic> data) {
    final String photoUrl =
    data['attachment'] != null ? data['attachment']['url'] ?? '' : '';
    return new Brand(data['en_name'], data['ar_name'], photoUrl);
  }

  final String enName;
  final String arName;
  final String photoUrl;

  Brand(this.enName, this.arName, this.photoUrl);

  Brand.from(Brand source)
      : this.enName = source.enName,
        this.arName = source.arName,
        this.photoUrl = source.photoUrl;

  String getName(BuildContext context) {
    return AppTranslations
        .of(context)
        .locale
        .languageCode == "en"
        ? enName
        : arName;
  }

  String getTitle(BuildContext context) {
    final name = getName(context);
    return name.length >= 12 ? '${name.substring(0, 12)}...' : name;
  }
}
