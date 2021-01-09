class User {
  final String token;

  final String userName;
  final String firstName;
  final String lastName;
  final String email;

  final int roleId;
  final int provinceId;
  final String phoneNumber;
  final String address;

  User.json(Map<String, dynamic> data, String token)
      : this(
            data['user_name'],
            data['first_name'],
            data['last_name'],
            data['email'],
            data['role_id'],
            data['province_id'],
            data['phone_number'],
            data['address'],
            token);

  User(this.userName, this.firstName, this.lastName, this.email, this.roleId,
      this.provinceId, this.phoneNumber, this.address, this.token);

  String get name => "${this.firstName} ${this.lastName}";

  Map<String, dynamic> toJson() {
    return {
      'user_name': this.userName,
      'first_name': this.userName,
      'last_name': this.lastName,
      'email': this.email,
      'role_id': this.roleId,
      'province_id': this.provinceId,
      'phone_number': this.phoneNumber,
      'address': this.address,
    };
  }

  Map<String, dynamic> toClient() {
    return {
      'name': this.name,
      'email': this.email,
      'province': this.provinceId,
      'phone': this.phoneNumber,
      'address': this.address,
    };
  }
}
