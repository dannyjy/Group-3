import 'package:flutter/material.dart';
import 'package:group_3/common/widgets/custom_app_bar.dart';
import 'package:group_3/common/widgets/custom_button.dart';
import 'package:group_3/features/auth/widgets/auth_text_field.dart';
import 'package:group_3/features/product/services/product_service.dart';
import 'package:group_3/models/product.dart';
import 'package:provider/provider.dart';
import 'package:group_3/common/utils/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-detail-screen';
  final Product? product; // Nullable for new, but here used for existing

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool _isLoading = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _productNameController.text = widget.product!.name;
      _quantityController.text = widget.product!.quantity.toString();
      _selectedCategory = widget.product!.category;
    } else {
      _selectedCategory = AppConstants.productCategories.first;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    if (widget.product == null) return; // Should not happen for update

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
    String result = await productService.updateProduct(
      productId: widget.product!.id,
      name: _productNameController.text,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      category: _selectedCategory!,
    );

    setState(() {
      _isLoading = false;
    });

    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pop(context); // Go back to product list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  void _deleteProduct() async {
    if (widget.product == null) return;

    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {
        _isLoading = true;
      });

      final productService =
          Provider.of<ProductService>(context, listen: false);
      String result = await productService.deleteProduct(
        productId: widget.product!.id,
      );

      setState(() {
        _isLoading = false;
      });

      if (result == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully!')),
        );
        Navigator.pop(context); // Go back to product list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Product Details'),
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
                : Column(
                    children: [
                      CustomButton(
                        text: 'Update Product',
                        onPressed: _updateProduct,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: 'Delete Product',
                        onPressed: _deleteProduct,
                        color: Colors.red,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
