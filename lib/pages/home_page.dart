import 'package:ecommerce_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/controller/home_controller.dart';
import 'package:ecommerce_app/pages/cart_page.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/pages/product_description_page.dart';
import 'package:ecommerce_app/widgets/drop_down_buton.dart';
import 'package:ecommerce_app/widgets/multi_select_drop_down.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: const Text(
              'Electronics Store',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.productCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          ctrl.filterByCategory(ctrl.productCategories[index].name ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Chip(
                            label: Text(
                              ctrl.productCategories[index].name ?? 'Null',
                              style: const TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
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
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: DropDownBtn(
                            items: const ['Low to High', 'High to Low'],
                            selectedItemText: 'Sort',
                            onSelected: (selected) {
                              ctrl.sortByPrice(ascending: selected == 'Low to High');
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
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: MultiSelectDropDown(
                            items: const ['Samsung', 'Apple', 'Sony', 'Asus'],
                            onSelectionChanged: (selectedItems) {
                              ctrl.filterByBrand(selectedItems);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return ProductWidget(
                      name: ctrl.productShowInUI[index].name ?? 'No name',
                      imageUrl: ctrl.productShowInUI[index].image ?? 'url',
                      price: ctrl.productShowInUI[index].price ?? 00,
                      offer: '20% off',
                      onTap: () {
                        Get.to(
                              () => ProductDescriptionPage(),
                          arguments: ctrl.productShowInUI[index].id ?? '',
                        );
                      },
                    );
                  },
                  childCount: ctrl.productShowInUI.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7, // Điều chỉnh để tránh tràn
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }),


     CartPage(),
     ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String offer;
  final VoidCallback onTap;

  const ProductWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.offer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$$price',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Chip(
                    label: Text(
                      offer,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


