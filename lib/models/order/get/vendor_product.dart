import 'package:json_annotation/json_annotation.dart';

import 'vendor.dart';
import 'vendor_product_data.dart';

part 'vendor_product.g.dart';

@JsonSerializable()
class VendorProduct {
  final int id;
  final int price;
  @JsonKey(name: 'sale_price')
  final salePrice;
  @JsonKey(name: 'sale_price_from')
  final salePriceFrom;
  @JsonKey(name: 'sale_price_to')
  final salePriceTo;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @JsonKey(name: 'stock_low_threshold')
  final int stockLowThreshold;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'vendor_id')
  final int vendorId;
  final Vendor vendor;
  final VendorProductData product;

  VendorProduct(
      this.id,
      this.price,
      this.salePrice,
      this.salePriceFrom,
      this.salePriceTo,
      this.stockQuantity,
      this.stockLowThreshold,
      this.productId,
      this.vendorId,
      this.vendor,
      this.product);

  factory VendorProduct.fromJson(Map<String, dynamic> json) =>
      _$VendorProductFromJson(json);

  Map<String, dynamic> toJson() => _$VendorProductToJson(this);
}
