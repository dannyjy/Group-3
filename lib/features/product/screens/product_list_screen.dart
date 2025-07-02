import 'package:flutter/material.dart';
import 'package:group_3/common/widgets/custom_app_bar.dart';
import 'package:group_3/features/product/screens/add_product_screen.dart';
import 'package:group_3/features/product/screens/product_detail_screen.dart';
import 'package:group_3/features/product/services/product_service.dart';
import 'package:group_3/models/product.dart';
import 'package:group_3/features/product/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:group_3/common/utils/constants.dart';

class ProductListScreen extends StatefulWidget {
  static const String routeName = '/product-list-screen';
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? _selectedFilterCategory;

  @override
  void initState() {
    super.initState();
    _selectedFilterCategory = 'All'; // Default filter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Products',
        showLogout: true,
        // Adding a filter dropdown to the AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedFilterCategory,
              decoration: InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              items: ['All', ...AppConstants.productCategories].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilterCategory = newValue;
                });
              },
            ),
          ),
        ),
      ),
      body: Consumer<ProductService>(
        builder: (context, productService, child) {
          List<Product> products = productService.products;

          // Apply category filter
          if (_selectedFilterCategory != 'All' && _selectedFilterCategory != null) {
            products = products
                .where((product) => product.category == _selectedFilterCategory)
                .toList();
          }

          if (products.isEmpty) {
            return const Center(child: Text('No products added yet or matching filter.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetailScreen.routeName,
                    arguments: product,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddProductScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}