import 'package:dspatch_user/models/products/addOnChoices.dart';
import 'package:dspatch_user/models/products/title.dart';
import 'package:json_annotation/json_annotation.dart';

part 'addOnGroups.g.dart';

@JsonSerializable()
class AddOnGroups {
  final int id;
  final Title title;
  @JsonKey(name: 'max_choice')
  final int maxChoice;
  @JsonKey(name: 'min_choice')
  final int minChoice;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'addon_choices')
  final List<AddOnChoices> addOnChoices;

  AddOnGroups(this.id, this.title, this.maxChoice, this.minChoice,
      this.productId, this.addOnChoices);

  factory AddOnGroups.fromJson(Map<String, dynamic> json) =>
      _$AddOnGroupsFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnGroupsToJson(this);
}
