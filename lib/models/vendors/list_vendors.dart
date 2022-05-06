import 'package:dspatch_user/models/vendors/vendordata.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_vendors.g.dart';

@JsonSerializable()
class ListVendors {
  @JsonKey(name: 'data')
  final List<Vendor> listOfData;

  ListVendors(this.listOfData);
  factory ListVendors.fromJson(Map<String, dynamic> json) =>
      _$ListVendorsFromJson(json);

  Map<String, dynamic> toJson() => _$ListVendorsToJson(this);
}
