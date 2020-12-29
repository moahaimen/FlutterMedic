enum PromoCodeType { Percentage, Constant }

class OrderPromoCode {
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

  OrderPromoCode.empty()
      : this(null, PromoCodeType.Percentage, null, valid: false);

  OrderPromoCode.json(Map<String, dynamic> data)
      : this(data['code'], PromoCodeType.values[int.parse(data['type'])],
            num.parse(data['discount']),
            valid: false);
}
