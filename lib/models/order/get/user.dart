import 'package:dspatch_user/models/order/get/wallet.dart';
import 'package:dspatch_user/models/vendors/list_vendorImage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
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
  final ListVendorImage mediaurls;
  final int balance;
  final Wallet wallet;

  User(
      this.id,
      this.name,
      this.email,
      this.mobileNumber,
      this.mobileVerified,
      this.active,
      this.language,
      this.notification,
      this.meta,
      this.mediaurls,
      this.balance,
      this.wallet);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
