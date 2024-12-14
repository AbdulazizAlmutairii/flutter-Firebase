import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product.dart';

class EditProductPage extends StatelessWidget {
  final Product product;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController imageUrlController;

  EditProductPage({required this.product})
      : nameController = TextEditingController(text: product.name),
        descriptionController = TextEditingController(text: product.description),
        imageUrlController = TextEditingController(text: product.imageUrl);

  Future<void> saveProduct(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(product.id).update({
        'name': nameController.text,
        'description': descriptionController.text,
        'imageUrl': imageUrlController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            ElevatedButton(
              onPressed: () => saveProduct(context),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
