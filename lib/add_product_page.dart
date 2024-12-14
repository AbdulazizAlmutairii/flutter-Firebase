import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _image;

  // اختيار صورة من المعرض
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            // عرض الصورة التي تم اختيارها من الجهاز
            _image == null
                ? Icon(Icons.add_a_photo, size: 100)
                : Image.file(File(_image!.path), height: 100, width: 100),
            ElevatedButton(
              onPressed: _pickImage, // اختيار صورة عند الضغط على الزر
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // إضافة المنتج إلى Firebase
                // في هذه الحالة، قد تحتاج إلى رفع الصورة إلى Firebase Storage أولاً، ثم حفظ الرابط في Firestore
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
