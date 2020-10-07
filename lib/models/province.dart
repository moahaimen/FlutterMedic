import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/pagination.dart';
import 'package:flutter/material.dart';

class Province extends IModel {
  static Province fromJson(Map<String, dynamic> data) {
    return new Province(
        data['id'], data['en_name'], data['ar_name'], data['fees']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'en_name': this.enName,
      'ar_name': this.arName,
      'fees': this.fees
    };
  }

  final int id;
  final String enName;
  final String arName;
  final int fees;

  Province(this.id, this.enName, this.arName, this.fees);

  Province.from(Province source)
      : this.id = source.id,
        this.enName = source.enName,
        this.arName = source.arName,
        this.fees = source.fees;

  String getName(BuildContext context) {
    return AppTranslations.of(context).locale.languageCode == "en"
        ? enName
        : arName;
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
    return false;
  }
}
