import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final int id;
  final String name;
  final String email;
  final String mobile;
  String formatted_address;
  final address1;
  final address2;
  final double longitude;
  final double latitude;
  @JsonKey(name: 'order_id')
  final int orderId;

  Address(
      this.id,
      this.name,
      this.email,
      this.mobile,
      this.formatted_address,
      this.address1,
      this.address2,
      this.longitude,
      this.latitude,
      this.orderId);

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String get formattedAddress {
    if (formatted_address == null) return "";
    while (formatted_address.contains(", , "))
      formatted_address = formatted_address.replaceAll(", , ", ", ");
    return formatted_address;
  }
}
