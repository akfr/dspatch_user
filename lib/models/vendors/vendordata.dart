import 'package:dspatch_user/models/user/media_library.dart';
import 'package:dspatch_user/models/vendors/vendorcategory.dart';
import 'package:dspatch_user/models/vendors/vendoruserdata_json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendordata.g.dart';

@JsonSerializable()
class Vendor {
  final int id;
  final String name;
  final String tagline;
  final String details;
  final meta;

  @JsonKey(name: 'mediaurls')
  final MediaLibrary mediaUrls;

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
  final List<VendorCategory> categories;
  final VendorUserData user;
  final int rating;
  @JsonKey(name: 'ratings_count')
  final int ratingCount;
  @JsonKey(name: 'favourite_count')
  final int favouriteCount;
  @JsonKey(name: 'is_favourite')
  final bool isFavourite;
  @JsonKey(ignore: true)
  bool isTapped = false;

  Vendor(
      this.id,
      this.name,
      this.tagline,
      this.details,
      this.meta,
      this.mediaUrls,
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
      this.categories,
      this.user,
      this.rating,
      this.ratingCount,
      this.favouriteCount,
      this.isFavourite,
      {this.isTapped = false});

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  Map<String, dynamic> toJson() => _$VendorToJson(this);

  @override
  String toString() {
    return 'Vendor(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vendor && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
