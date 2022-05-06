import 'package:dspatch_user/models/payment_method/title_translations.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_mode.g.dart';

@JsonSerializable()
class DeliveryMode {
  final int id;
  final String title;

  @JsonKey(name: 'title_translations')
  final TitleTranslations titleTranslations;

  final String detail;

  @JsonKey(name: 'detail_translations')
  final TitleTranslations detailTranslations;

  final meta;
  final int price;
  final int enabled;

  DeliveryMode(this.id, this.title, this.titleTranslations, this.detail,
      this.detailTranslations, this.meta, this.price, this.enabled);

  factory DeliveryMode.fromJson(Map<String, dynamic> json) =>
      _$DeliveryModeFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryModeToJson(this);
}
