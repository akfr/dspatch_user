import 'package:dspatch_user/models/custom_delivery/delivery_mode.dart';
import 'package:dspatch_user/models/custom_delivery/meta_custom.dart';
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';
import 'delivery_data.dart';
import 'payment.dart';
import 'product.dart';
import 'user.dart';
import 'vendor.dart';

part 'order_data.g.dart';

@JsonSerializable()
class OrderData {
  final int id;
  final String notes;
  final MetaCustom meta;
  final int subtotal;
  final double taxes;
  @JsonKey(name: 'delivery_fee')
  final int deliveryFee;
  final double total;
  final double discount;
  @JsonKey(name: 'order_type')
  final String orderType;
  final String type;
  @JsonKey(name: 'scheduled_on')
  final String scheduledOn;
  final String status;
  @JsonKey(name: 'vendor_id')
  final int vendorId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final List<Product> products;
  final Vendor vendor;
  final User user;
  final Address address;
  @JsonKey(name: 'source_address')
  final Address sourceAddress;
  final DeliveryData delivery;
  final Payment payment;
  @JsonKey(name: 'delivery_mode')
  final DeliveryMode deliveryMode;

  static orderLabel(String type) {
    //type: orders_pending or orders_past
    return OrderData(
        type == "orders_pending" ? -1 : -2,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        type,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null);
  }

  OrderData(
      this.id,
      this.notes,
      this.meta,
      this.subtotal,
      this.taxes,
      this.deliveryFee,
      this.total,
      this.discount,
      this.orderType,
      this.type,
      this.scheduledOn,
      this.status,
      this.vendorId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.products,
      this.vendor,
      this.user,
      this.address,
      this.sourceAddress,
      this.delivery,
      this.payment,
      this.deliveryMode);

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataToJson(this);

  bool isComplete() {
    return status == "complete" ||
        status == "cancelled" ||
        status == "rejected" ||
        status == "refund" ||
        status == "failed";
  }
}
