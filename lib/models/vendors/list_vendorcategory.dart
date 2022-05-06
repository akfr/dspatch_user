import 'package:dspatch_user/models/vendors/vendorcategory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_vendorcategory.g.dart';

@JsonSerializable()
class ListVendorCategory {
  final List<VendorCategory> categories;

  ListVendorCategory(this.categories);
  factory ListVendorCategory.fromJson(Map<String, dynamic> json) =>
      _$ListVendorCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ListVendorCategoryToJson(this);
}
