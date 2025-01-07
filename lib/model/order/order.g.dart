// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Orders _$OrderFromJson(Map<String, dynamic> json) => Orders(
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      address: json['address'] as String?,
      orderDate: json['orderDate'] == null
          ? null
          : DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String?,
);

Map<String, dynamic> _$OrderToJson(Orders instance) => <String, dynamic>{
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'phoneNumber': instance.phoneNumber,
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'address': instance.address,
      'orderDate': instance.orderDate?.toIso8601String(),
      'status': instance.status,
};