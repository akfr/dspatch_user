// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderData _$OrderDataFromJson(Map<String, dynamic> json) {
  return OrderData(
    json['id'] as int,
    json['notes'] as String,
    json['meta'] == null
        ? null
        : MetaCustom.fromJson(json['meta'] as Map<String, dynamic>),
    json['subtotal'] as int,
    (json['taxes'] as num)?.toDouble(),
    json['delivery_fee'] as int,
    (json['total'] as num)?.toDouble(),
    (json['discount'] as num)?.toDouble(),
    json['order_type'] as String,
    json['type'] as String,
    json['scheduled_on'] as String,
    json['status'] as String,
    json['vendor_id'] as int,
    json['user_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
    (json['products'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['vendor'] == null
        ? null
        : Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
    json['source_address'] == null
        ? null
        : Address.fromJson(json['source_address'] as Map<String, dynamic>),
    json['delivery'] == null
        ? null
        : DeliveryData.fromJson(json['delivery'] as Map<String, dynamic>),
    json['payment'] == null
        ? null
        : Payment.fromJson(json['payment'] as Map<String, dynamic>),
    json['delivery_mode'] == null
        ? null
        : DeliveryMode.fromJson(json['delivery_mode'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'meta': instance.meta,
      'subtotal': instance.subtotal,
      'taxes': instance.taxes,
      'delivery_fee': instance.deliveryFee,
      'total': instance.total,
      'discount': instance.discount,
      'order_type': instance.orderType,
      'type': instance.type,
      'scheduled_on': instance.scheduledOn,
      'status': instance.status,
      'vendor_id': instance.vendorId,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'products': instance.products,
      'vendor': instance.vendor,
      'user': instance.user,
      'address': instance.address,
      'source_address': instance.sourceAddress,
      'delivery': instance.delivery,
      'payment': instance.payment,
      'delivery_mode': instance.deliveryMode,
    };
