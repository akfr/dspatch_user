import 'package:dspatch_user/models/payment_method/title_translations.dart';
import 'package:dspatch_user/models/user/media_library.dart';
import 'package:dspatch_user/models/vendors/vendorMeta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'banner_data.g.dart';

@JsonSerializable()
class BannerData {
  final int id;
  final String title;
  @JsonKey(name: 'title_translations')
  final TitleTranslations titleTranslations;
  final VendorMeta meta;
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  final MediaLibrary mediaurls;

  BannerData(this.id, this.title, this.titleTranslations, this.meta,
      this.sortOrder, this.mediaurls);

  factory BannerData.fromJson(Map<String, dynamic> json) =>
      _$BannerDataFromJson(json);

  Map<String, dynamic> toJson() => _$BannerDataToJson(this);
}
