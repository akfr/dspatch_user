import 'package:json_annotation/json_annotation.dart';

part 'vendorImage.g.dart';

@JsonSerializable()
class VendorImage {
  @JsonKey(name: 'default')
  final String defaultImage;
  @JsonKey(name: 'thumb')
  final String thumbImage;
  VendorImage(this.defaultImage, this.thumbImage);

  factory VendorImage.fromJson(Map<String, dynamic> json) =>
      _$VendorImageFromJson(json);

  Map<String, dynamic> toJson() => _$VendorImageToJson(this);
}
