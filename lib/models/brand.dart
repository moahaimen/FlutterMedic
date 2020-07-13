class Brand {
  final String name;
  final String photoUrl;

  Brand(this.name, this.photoUrl);

  String get title => this.name.substring(0, 2).toUpperCase();
}
