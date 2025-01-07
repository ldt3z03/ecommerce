// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      productId: json['product_id'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      image: json['image'] as String?,
      productCategory: json['category'] as String?,
      isOffer: json['offer'] as bool?,
      userId: json['user_id'] as String?,
    )..id = json['id'] as String?;

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
      'image': instance.image,
      'category': instance.productCategory,
      'offer': instance.isOffer,
      'user_id': instance.userId,
    };
