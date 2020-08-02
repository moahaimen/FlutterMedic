enum PromoCodeType { Percentage, Constant }

class OrderPromoCode {
  static OrderPromoCode fromJson(Map<String, dynamic> data) {
    if (data == null) return null;
    return new OrderPromoCode(
        data['code'],
        PromoCodeType.values[int.parse(data['type'])],
        num.parse(data['discount']),
        valid: false);
  }

  dynamic toJson(bool isPost) {
    return isPost
        ? this.code
        : {
            'code': this.code,
            'type': this.type.index,
            'discount': this.discount
          };
  }

  final String code;
  final PromoCodeType type;
  final num discount;

  bool valid;

  OrderPromoCode(this.code, this.type, this.discount, {this.valid});
}
