// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postOrder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostOrder _$PostOrderFromJson(Map<String, dynamic> json) {
  return PostOrder(
    json['address_id'] as int,
    json['payment_method_slug'] as String,
    json['products'] == null
        ? null
        : ListProducts.fromJson(json['products'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PostOrderToJson(PostOrder instance) => <String, dynamic>{
      'address_id': instance.addressId,
      'payment_method_slug': instance.paymentMethodSlug,
      'products': instance.products,
    };
