import 'package:dspatch_user/models/vendors/vendoruserdata_json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendor.g.dart';

@JsonSerializable()
class Vendor {
  final int id;
  final String name;
  final String tagline;
  final String details;
  final meta;

  @JsonKey(name: 'mediaurls')
  final List mediaUrls;

  @JsonKey(name: 'minimum_order')
  final int minimumOrder;

  @JsonKey(name: 'delivery_fee')
  final int deliveryFee;
  final String area;
  final String address;
  final double longitude;
  final double latitude;

  @JsonKey(name: 'is_verified')
  final int isVerified;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  final VendorUserData user;
  final int rating;
  @JsonKey(name: 'ratings_count')
  final int ratingCount;
  @JsonKey(name: 'favourite_count')
  final int favouriteCount;
  @JsonKey(name: 'is_favourite')
  final bool isFavourite;

  Vendor(
      this.id,
      this.name,
      this.tagline,
      this.details,
      this.meta,
      this.minimumOrder,
      this.deliveryFee,
      this.area,
      this.address,
      this.longitude,
      this.latitude,
      this.isVerified,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.rating,
      this.ratingCount,
      this.favouriteCount,
      this.isFavourite,
      this.mediaUrls);

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  Map<String, dynamic> toJson() => _$VendorToJson(this);
}
