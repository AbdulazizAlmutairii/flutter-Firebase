import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddProductPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // التحقق من تسجيل الدخول
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You must be logged in to add products!')),
                  );
                  return;
                }

                // إضافة المنتج إلى Firestore
                await FirebaseFirestore.instance.collection('products').add({
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'imageUrl': imageUrlController.text,
                });

                // الرجوع إلى الصفحة الرئيسية
                Navigator.pop(context);
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
