import 'package:dspatch_user/models/vendors/list_vendorImage.dart';
import 'package:dspatch_user/models/vendors/vendorMeta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendorcategory.g.dart';

@JsonSerializable()
class VendorCategory {
  final int id;
  final String slug;
  final String title;
  final VendorMeta meta;

  @JsonKey(name: 'sort_order')
  final int sortOrder;

  final ListVendorImage mediaurls;

  @JsonKey(name: 'parent_id')
  final parentId;

  VendorCategory(this.id, this.slug, this.title, this.meta, this.sortOrder,
      this.mediaurls, this.parentId);
  factory VendorCategory.fromJson(Map<String, dynamic> json) =>
      _$VendorCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$VendorCategoryToJson(this);
}
