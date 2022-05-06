import 'package:dspatch_user/models/vendors/links_json.dart';
import 'package:dspatch_user/models/vendors/meta_json.dart';
import 'package:json_annotation/json_annotation.dart';

import 'order_data.dart';

part 'list_order.g.dart';

@JsonSerializable()
class ListOrder {
  @JsonKey(name: 'data')
  final List<OrderData> listOfOrder;

  final Links links;
  final Meta meta;

  ListOrder(this.listOfOrder, this.links, this.meta);

  factory ListOrder.fromJson(Map<String, dynamic> json) =>
      _$ListOrderFromJson(json);

  Map<String, dynamic> toJson() => _$ListOrderToJson(this);
}
