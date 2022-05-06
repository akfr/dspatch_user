import 'package:json_annotation/json_annotation.dart';

part 'meta_json.g.dart';

@JsonSerializable()
class Meta {
  @JsonKey(name: 'current_page')
  final int currentPage;

  final int from;

  @JsonKey(name: 'last_page')
  final int lastPage;

  final String path;

  @JsonKey(name: 'per_page')
  final int perPage;

  final int to;
  final int total;

  Meta(this.currentPage, this.from, this.lastPage, this.path, this.perPage,
      this.to, this.total);
  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
