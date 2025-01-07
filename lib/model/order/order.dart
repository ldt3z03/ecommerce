import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Orders {
  @JsonKey(name: "customerId")
  String? customerId;

  @JsonKey(name: "customerName")
  String? customerName;

  @JsonKey(name: "phoneNumber")
  String? phoneNumber;

  @JsonKey(name: "productId")
  String? productId;

  @JsonKey(name: "productName")
  String? productName;


  @JsonKey(name: "quantity")
  int? quantity;

  @JsonKey(name: "price")
  double? price;

  @JsonKey(name: "totalPrice")
  double? totalPrice;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "address")
  String? address;

  @JsonKey(name: "orderDate")
  DateTime? orderDate;

  @JsonKey(name: "status")
  String? status;

  Orders({
    this.customerId,
    this.customerName,
    this.phoneNumber,
    this.image,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.totalPrice,
    this.address,
    this.orderDate,
    this.status,
  });

  // Factory method for JSON deserialization
  factory Orders.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}