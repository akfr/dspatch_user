import 'package:dspatch_user/models/vendors/vendorImage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_vendorImage.g.dart';

@JsonSerializable()
class ListVendorImage {
  final List<VendorImage> images;

  ListVendorImage(this.images);

  factory ListVendorImage.fromJson(Map<String, dynamic> json) =>
      _$ListVendorImageFromJson(json);

  Map<String, dynamic> toJson() => _$ListVendorImageToJson(this);
}
