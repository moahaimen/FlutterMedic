import 'package:drugStore/models/pagination.dart';

class ContactUs extends IModel {
  static ContactUs fromJson(Map<String, dynamic> data) {
    return new ContactUs(
      data['section'],
      data['key'],
      data['en_value'],
      data['ar_value'],
      data['url'],
    );
  }

  final String section;
  final String key;
  final String enValue;
  final String arValue;
  final String url;

  ContactUs(this.section, this.key, this.enValue, this.arValue, this.url);

  @override
  int get identifier => this.hashCode;

  @override
  bool verify(Map<String, dynamic> filter) {
    if (filter == null || filter.isEmpty) {
      return true;
    }

    if (filter.containsKey('value')) {
      final value = filter['value'];
      return this.enValue.contains(value) || this.arValue.contains(value);
    }
    return false;
  }
}
