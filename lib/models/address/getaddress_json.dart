import 'package:json_annotation/json_annotation.dart';

part 'getaddress_json.g.dart';

@JsonSerializable()
class GetAddress {
  final int id;
  final String title;
  final meta;
  @JsonKey(name: 'formatted_address')
  final String formattedAddress;
  final address1;
  final address2;
  final country;
  final state;
  final city;
  final postcode;
  final double longitude;
  final double latitude;
  @JsonKey(name: 'user_id')
  final int userId;

  GetAddress(
      this.id,
      this.title,
      this.meta,
      this.formattedAddress,
      this.address1,
      this.address2,
      this.country,
      this.state,
      this.city,
      this.postcode,
      this.longitude,
      this.latitude,
      this.userId);

  factory GetAddress.fromJson(Map<String, dynamic> json) =>
      _$GetAddressFromJson(json);

  Map<String, dynamic> toJson() => _$GetAddressToJson(this);
}
