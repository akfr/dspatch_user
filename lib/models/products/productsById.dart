import 'package:dspatch_user/models/products/addOnGroups.dart';
import 'package:dspatch_user/models/products/vendorproduct_json.dart';
import 'package:dspatch_user/models/vendors/list_vendorImage.dart';
import 'package:dspatch_user/models/vendors/vendorcategory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'productsById.g.dart';

@JsonSerializable()
class ProductById {
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
  @JsonKey(name: 'mediaurls')
  final ListVendorImage mediaUrls;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'addon_groups')
  final List<AddOnGroups> addOnGroups;
  final List<VendorCategory> categories;
  @JsonKey(name: 'vendor_product')
  final List<VendorProduct> vendorProduct;

  ProductById(
      this.id,
      this.title,
      this.detail,
      this.meta,
      this.price,
      this.owner,
      this.parentId,
      this.attributeTermId,
      this.createdAt,
      this.updatedAt,
      this.addOnGroups,
      this.categories,
      this.vendorProduct,
      this.mediaUrls);

  factory ProductById.fromJson(Map<String, dynamic> json) =>
      _$ProductByIdFromJson(json);

  Map<String, dynamic> toJson() => _$ProductByIdToJson(this);
}
