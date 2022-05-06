import 'package:dspatch_user/models/vendors/links_json.dart';
import 'package:dspatch_user/models/vendors/meta_json.dart';
import 'package:json_annotation/json_annotation.dart';

import 'banner_data.dart';

part 'banner_list.g.dart';

@JsonSerializable()
class BannerList {
  @JsonKey(name: 'data')
  final List<BannerData> listOfBanner;

  final Links links;
  final Meta meta;

  BannerList(this.listOfBanner, this.links, this.meta);

  factory BannerList.fromJson(Map<String, dynamic> json) =>
      _$BannerListFromJson(json);

  Map<String, dynamic> toJson() => _$BannerListToJson(this);
}
