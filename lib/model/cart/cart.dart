import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "product_id")
  String? productId;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "price")
  double? price;

  @JsonKey(name: "quantity")
  int? quantity;

  @JsonKey(name: "total_price")
  double? totalPrice;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "category")
  String? productCategory;

  @JsonKey(name: "offer")
  bool? isOffer;

  @JsonKey(name: "user_id")
  String? userId;
  // Constructor
  Cart({
    this.productId,
    this.name,
    this.price,
    this.quantity,
    this.totalPrice,
    this.image,
    this.productCategory,
    this.isOffer,
    this.userId,
  });

  void updateTotalPrice() {
    totalPrice = (price ?? 0) * (quantity ?? 1);
  }

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}
