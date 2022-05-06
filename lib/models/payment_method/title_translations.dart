import 'package:json_annotation/json_annotation.dart';

part 'title_translations.g.dart';

@JsonSerializable()
class TitleTranslations {
  final String en;

  TitleTranslations(this.en);

  factory TitleTranslations.fromJson(Map<String, dynamic> json) =>
      _$TitleTranslationsFromJson(json);

  Map<String, dynamic> toJson() => _$TitleTranslationsToJson(this);
}
