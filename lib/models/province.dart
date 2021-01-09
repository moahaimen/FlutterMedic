class Province {
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
  final double fees;

  const Province(this.id, this.enName, this.arName, this.fees);

  Province.json(Map<String, dynamic> data, double exchange)
      : this(
          data['id'],
          data['en_name'],
          data['ar_name'],
          data['fees'] * exchange,
        );

  String getName(String locale) {
    return locale == "en" ? enName : arName;
  }
}
