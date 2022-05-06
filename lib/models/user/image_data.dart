import 'package:json_annotation/json_annotation.dart';

part 'image_data.g.dart';

@JsonSerializable()
class ImageData {
  @JsonKey(name: 'default')
  final String defaultImage;
  final String thumb;
  final String small;
  final String medium;
  final String large;
  ImageData(
    this.defaultImage,
    this.thumb,
    this.small,
    this.medium,
    this.large,
  );
  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);
  Map<String, dynamic> toJson() => _$ImageDataToJson(this);
}
