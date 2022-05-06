import 'package:dspatch_user/models/products/productsById.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listproducts.g.dart';

@JsonSerializable()
class ListProduct {
  @JsonKey(name: 'data')
  final List<ProductById> listOfData;

  ListProduct(this.listOfData);
  factory ListProduct.fromJson(Map<String, dynamic> json) =>
      _$ListProductFromJson(json);

  Map<String, dynamic> toJson() => _$ListProductToJson(this);
}
