class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final List<AddressModel> addresses;
  final List<PaymentMethodModel> paymentMethods;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.addresses,
    required this.paymentMethods,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    List<AddressModel>? addresses,
    List<PaymentMethodModel>? paymentMethods,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}

class AddressModel {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });
}

class PaymentMethodModel {
  final String id;
  final String type;
  final String lastFourDigits;
  final String expiryDate;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.lastFourDigits,
    required this.expiryDate,
    this.isDefault = false,
  });
}