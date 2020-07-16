import 'package:drugStore/models/attachment.dart';
import 'package:drugStore/models/brand.dart';
import 'package:drugStore/models/category.dart';

class Product {
  static Product fromJson(Map<String, dynamic> data) {
    final brand = new Brand(data['brand']['name'], data['brand']['photoUrl']);
    final category =
        new Category(data['category']['name'], data['category']['description']);

    final List<Attachment> attachments = (data['attachments'] as List<dynamic>)
        .map((e) => new Attachment(
            e['type'] == 0 ? AttachmentType.Image : AttachmentType.Video,
            e['url']))
        .toList();

    return new Product(
        data['id'],
        data['name'],
        data['description'],
        data['price']['value'],
        DateTime.parse(data['price']['updated_at']),
        attachments,
        brand,
        category,
        data['is_main']);
  }

  final int id;
  final String name;
  final String description;
  final num price;
  final DateTime dateOfPriceChange;
  final Brand brand;
  final Category category;
  final List<Attachment> attachments;
  final bool isMain;

  Product(
      this.id,
      this.name,
      this.description,
      this.price,
      this.dateOfPriceChange,
      this.attachments,
      this.brand,
      this.category,
      this.isMain);

  String get title =>
      this.name.length >= 20 ? '${this.name.substring(0, 17)}...' : this.name;

  Attachment get image => this
      .attachments
      .firstWhere((element) => element.type == AttachmentType.Image);
}
