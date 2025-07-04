import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_3/models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new product
  Future<String> addProduct({
    required String name,
    required String quantity,
    required String category,
  }) async {
    String res = "Some error occurred";
    try {
      if (name.isEmpty || quantity.isEmpty) {
        return "Please fill all fields";
      }
      String productId = const Uuid().v1();

      Product product = Product(
        id: productId,
        name: name,
        quantity: int.parse(quantity),
        category: category,
      );

      await _firestore
          .collection('products')
          .doc(productId)
          .set(product.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Edit an existing product
  Future<String> editProduct({
    required String productId,
    required String name,
    required String quantity,
    required String category,
  }) async {
    String res = "Some error occurred";
    try {
      Map<String, dynamic> updateData = {
        'name': name,
        'quantity': int.tryParse(quantity) ?? 0,
        'category': category,
      };

      await _firestore.collection('products').doc(productId).update(updateData);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete a product
  Future<String> deleteProduct(String productId) async {
    String res = "Some error occurred";
    try {
      // Note: You should also delete the product image from Firebase Storage
      await _firestore.collection('products').doc(productId).delete();
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // Fetch all products
  Future<List<Product>> products() async {
    List<Product> products = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      for (var doc in snapshot.docs) {
        products.add(Product.fromSnap(doc));
      }
    } catch (err) {
      print("Error fetching products: $err");
    }
    return products;
  }

  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnap(doc)).toList();
    });
  }
}