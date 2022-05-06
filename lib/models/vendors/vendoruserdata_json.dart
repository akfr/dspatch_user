import 'package:json_annotation/json_annotation.dart';

part 'vendoruserdata_json.g.dart';

@JsonSerializable()
class VendorUserData {
  final int id;
  final String name;
  final String email;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  @JsonKey(name: 'mobile_verified')
  final int mobileVerified;

  final int active;
  final String language;
  final notification;
  final meta;

  @JsonKey(name: 'remember_token')
  final rememberToken;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  VendorUserData(
      this.id,
      this.name,
      this.email,
      this.mobileNumber,
      this.mobileVerified,
      this.active,
      this.language,
      this.notification,
      this.meta,
      this.rememberToken,
      this.createdAt,
      this.updatedAt);

  factory VendorUserData.fromJson(Map<String, dynamic> json) =>
      _$VendorUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$VendorUserDataToJson(this);
}
