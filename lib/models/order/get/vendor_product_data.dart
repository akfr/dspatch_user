import 'package:json_annotation/json_annotation.dart';

part 'vendor_product_data.g.dart';

@JsonSerializable()
class VendorProductData {
  final int id;
  final String title;
  final String detail;
  final meta;
  final int price;
  final String owner;

  @JsonKey(name: 'parent_id')
  final parentId;

  @JsonKey(name: 'attribute_term_id')
  final attributeTermId;

  final List mediaurls;
  final String createdAt;
  final String updatedAt;

  VendorProductData(
      this.id,
      this.title,
      this.detail,
      this.meta,
      this.price,
      this.owner,
      this.parentId,
      this.attributeTermId,
      this.mediaurls,
      this.createdAt,
      this.updatedAt);

  factory VendorProductData.fromJson(Map<String, dynamic> json) =>
      _$VendorProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$VendorProductDataToJson(this);
}
