import 'package:ecommerce_app/controller/home_controller.dart';
import 'package:ecommerce_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/pages/product_description_page.dart';
import 'package:ecommerce_app/widgets/drop_down_buton.dart';
import 'package:ecommerce_app/widgets/multi_select_drop_down.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../widgets/product_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async
        {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Electronics Store',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  GetStorage box = GetStorage();
                  box.erase();
                  Get.offAll(LoginPage());
                },
                icon: const Icon(Icons.logout, color: Colors.black54),
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.productCategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        ctrl.filterByCategory(ctrl.productCategories[index].name ?? '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Chip(label: Text(ctrl.productCategories[index].name ?? 'Null')),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropDownBtn(
                          items: const ['Low to High', 'High to Low'],
                          selectedItemText: 'Sort',
                          onSelected: (selected) {
                            ctrl.sortByPrice(ascending: selected == 'Low to High' ? true : false);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: MultiSelectDropDown(
                          items: ['Samsung', 'Apple','Sonny','Asus'],
                          onSelectionChanged: (selectedItems) {
                            ctrl.filterByBrand(selectedItems);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: ctrl.productShowInUI.length,
                  itemBuilder: (context, index) {
                    return ProductWidget(
                      name: ctrl.productShowInUI[index].name ?? 'No name',
                      imageUrl: ctrl.productShowInUI[index].image ?? 'url',
                      price: ctrl.productShowInUI[index].price ?? 00,
                      offer: '20% off',
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                        const ProductDescriptionPage(
                        )
                        ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}