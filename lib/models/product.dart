import 'package:uuid/uuid.dart'; // Add uuid package to pubspec.yaml if not present

const uuid = Uuid();

class Product {
  final String id;
  final String name;
  final int quantity;
  final String category; // New field for category

  Product({
    String? id,
    required this.name,
    required this.quantity,
    required this.category,
  }) : id = id ?? uuid.v4(); // Generate a unique ID if not provided

  // For updating a product, copyWith allows creating a new instance with changed values
  Product copyWith({
    String? id,
    String? name,
    int? quantity,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }
}
