class Category {
  final String name;
  final String description;
  final int icon;
  final int color;

  Category(this.name, this.description, this.icon, this.color);

  String get title => this.name.substring(0, 2).toUpperCase();
}
