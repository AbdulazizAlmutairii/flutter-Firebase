class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
