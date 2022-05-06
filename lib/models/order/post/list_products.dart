import 'package:dspatch_user/models/order/post/products.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_products.g.dart';

@JsonSerializable()
class ListProducts {
  final List<Products> products;

  ListProducts(this.products);

  factory ListProducts.fromJson(Map<String, dynamic> json) =>
      _$ListProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ListProductsToJson(this);
}
