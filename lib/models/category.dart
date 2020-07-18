class CategoryIcon {
  final int name;

  CategoryIcon(this.name);

  String get url =>
      'https://molardentalmaterials.com/assets/img/icons/icon$name.png';
}

class Category {
  static Category fromJson(Map<String, dynamic> data) {
    final icon = new CategoryIcon(data['icon']);

    return new Category(data['name'], data['description'], icon);
  }

  final String name;
  final String description;
  final CategoryIcon icon;

  Category(this.name, this.description, this.icon);

  String get title => this.name.substring(0, 2).toUpperCase();
}
