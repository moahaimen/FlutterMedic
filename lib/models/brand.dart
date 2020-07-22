class Brand {
  final String name;
  final String photoUrl;

  Brand(this.name, this.photoUrl);

  String get title =>
      this.name.length >= 12 ? '${this.name.substring(0, 12)}...' : this.name;
}
