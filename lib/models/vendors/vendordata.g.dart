// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendordata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vendor _$VendorFromJson(Map<String, dynamic> json) {
  return Vendor(
    json['id'] as int,
    json['name'] as String,
    json['tagline'] as String,
    json['details'] as String,
    json['meta'],
    json['mediaurls'] == null
        ? null
        : MediaLibrary.fromJson(json['mediaurls'] as Map<String, dynamic>),
    json['minimum_order'] as int,
    json['delivery_fee'] as int,
    json['area'] as String,
    json['address'] as String,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['is_verified'] as int,
    json['user_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
    (json['categories'] as List)
        ?.map((e) => e == null
            ? null
            : VendorCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['user'] == null
        ? null
        : VendorUserData.fromJson(json['user'] as Map<String, dynamic>),
    json['rating'] as int,
    json['ratings_count'] as int,
    json['favourite_count'] as int,
    json['is_favourite'] as bool,
  );
}

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagline': instance.tagline,
      'details': instance.details,
      'meta': instance.meta,
      'mediaurls': instance.mediaUrls,
      'minimum_order': instance.minimumOrder,
      'delivery_fee': instance.deliveryFee,
      'area': instance.area,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'is_verified': instance.isVerified,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'categories': instance.categories,
      'user': instance.user,
      'rating': instance.rating,
      'ratings_count': instance.ratingCount,
      'favourite_count': instance.favouriteCount,
      'is_favourite': instance.isFavourite,
    };
