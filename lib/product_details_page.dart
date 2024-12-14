import 'package:flutter/material.dart';
import 'models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl, // هنا نعرض الصورة من الإنترنت
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported, size: 50);
              },
              height: 300, // تعيين ارتفاع الصورة
              width: 300, // تعيين عرض الصورة
            ),
            SizedBox(height: 10),
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              product.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
