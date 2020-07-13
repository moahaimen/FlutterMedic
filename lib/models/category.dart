class Category {
  final String name;
  final String description;

  Category(this.name, this.description);

  String get title => this.name.substring(0, 2).toUpperCase();
}
