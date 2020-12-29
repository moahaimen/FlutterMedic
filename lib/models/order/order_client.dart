import 'package:drugStore/models/province.dart';
import 'package:drugStore/utils/state.dart';

class OrderClient {
  String name;
  String phone;
  Province province;
  String address;
  String notes;

  OrderClient(this.name, this.phone, this.province, this.address, {this.notes});

  OrderClient.empty() : this(null, null, null, null);

  OrderClient.json(Map<String, dynamic> data, StateModel state)
      : this(
            data['name'],
            data['phone'],
            state.provinces.firstWhere((e) => e.id == data['province'],
                orElse: () => null),
            data['address'],
            notes: data['notes']);

  OrderClient.full(Map<String, dynamic> data)
      : this(data['name'], data['phone'], Province.json(data['province']),
            data['address'],
            notes: data['notes']);

  bool get completed {
    return this.name != null &&
        this.address != null &&
        this.province != null &&
        this.phone != null;
  }

  Map<String, dynamic> toJson(bool isPost) {
    return {
      'name': this.name,
      'phone': this.phone,
      'province_id': this.province?.id,
      'address': this.address,
      'notes': this.notes,
    };
  }
}
