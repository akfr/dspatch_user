import 'package:dspatch_user/models/custom_delivery/delivery_mode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_delivery_mode.g.dart';

@JsonSerializable()
class ListDeliveryMode {
  final List<DeliveryMode> data;

  ListDeliveryMode(this.data);

  factory ListDeliveryMode.fromJson(Map<String, dynamic> json) =>
      _$ListDeliveryModeFromJson(json);

  Map<String, dynamic> toJson() => _$ListDeliveryModeToJson(this);
}
