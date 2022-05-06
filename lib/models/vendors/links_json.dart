import 'package:json_annotation/json_annotation.dart';

part 'links_json.g.dart';

@JsonSerializable()
class Links {
  final String first;
  final String last;
  final dynamic prev;
  final dynamic next;

  Links(this.first, this.last, this.prev, this.next);

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}
