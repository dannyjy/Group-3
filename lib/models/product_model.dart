import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int quantity;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'category': category,
      };

  static Product fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Product(
      id: snapshot['id'] ?? snap.id,
      name: snapshot['name'] ?? '',
      quantity: int.tryParse(snapshot['quantity'].toString()) ?? 0,
      category: snapshot['category'] ?? '',
    );
  }
}
