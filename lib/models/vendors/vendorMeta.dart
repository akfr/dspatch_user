import 'package:json_annotation/json_annotation.dart';

part 'vendorMeta.g.dart';

@JsonSerializable()
class VendorMeta {
  final String scope;
  @JsonKey(name: 'store_name')
  final String storeName;

  VendorMeta(this.scope, this.storeName);

  factory VendorMeta.fromJson(Map<String, dynamic> json) =>
      _$VendorMetaFromJson(json);

  Map<String, dynamic> toJson() => _$VendorMetaToJson(this);
}
