import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/product_category/product_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/product/product.dart';

class HomeController extends GetxController{
  FirebaseFirestore firestore  = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products = [];
  List<Product> productShowInUI = [];
  List<ProductCategory> productCategories = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    await fetchCategory();
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs.map((doc) =>
          Product.fromJson(doc.data() as Map<String, dynamic>)).toList();
      products.clear();
      products.assignAll(retrievedProducts);
      productShowInUI.assignAll(products);
      Get.snackbar('Success', 'Product fetch successfully', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrievedCategories = categorySnapshot.docs.map((doc) =>
          ProductCategory.fromJson(doc.data() as Map<String, dynamic>)).toList();
      productCategories.clear();
      productCategories.assignAll(retrievedCategories);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  filterByCategory(String category){
      productShowInUI.clear();
      productShowInUI = products.where((product) => product.category == category).toList();
      update();
  }

  filterByBrand(List<String> brands) {
    if (brands.isEmpty) {
      productShowInUI = products;
    } else {
      List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase())
          .toList();
      productShowInUI = products.where((product) {
        return lowerCaseBrands.contains(product.brand?.toLowerCase());
      }).toList();
    }
    update();
  }

  sortByPrice({required bool ascending}) {
    List<Product> sortedProducts = List<Product>.from(productShowInUI);
    sortedProducts.sort((a,b)=> ascending? a. price!.compareTo(b.price!): b.price!.compareTo(a.price!));
    productShowInUI = sortedProducts;
    update();
  }
}