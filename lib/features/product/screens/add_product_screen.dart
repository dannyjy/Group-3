import 'package:flutter/material.dart';
import 'package:group_3/common/widgets/custom_app_bar.dart';
import 'package:group_3/common/widgets/custom_button.dart';
import 'package:group_3/features/auth/widgets/auth_text_field.dart';
import 'package:group_3/features/product/services/product_service.dart';
import 'package:provider/provider.dart';
import 'package:group_3/common/utils/constants.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product-screen';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool _isLoading = false;
  String? _selectedCategory; // For category dropdown

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        AppConstants.productCategories.first; // Default category
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addProduct() async {
    if (_productNameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select a category.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final productService = Provider.of<ProductService>(context, listen: false);
    String result = await productService.addProduct(
      name: _productNameController.text,
      quantity: _quantityController.text,
      category: _selectedCategory!,
    );

    setState(() {
      _isLoading = false;
    });

    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      Navigator.pop(context); // Go back to product list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add New Product'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _productNameController,
              hintText: 'Product Name',
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _quantityController,
              hintText: 'Quantity',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: AppConstants.productCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: 'Add Product',
                    onPressed: _addProduct,
                  ),
          ],
        ),
      ),
    );
  }
}
