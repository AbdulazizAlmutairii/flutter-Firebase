import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product.dart';
import 'editproductpage.dart';
import 'models/add_product_page.dart';
import 'product_details_page.dart';
import 'login_page.dart'; // صفحة تسجيل الدخول

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products List'),
      ),
      drawer: ProfileDrawer(), // إضافة القائمة الجانبية
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('products').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data!.docs.map((doc) {
            return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(
                  product.imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported);
                  },
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name),
                subtitle: Text(product.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(product: product),
                    ),
                  );
                },
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await checkAndNavigateToEditPage(context, product);
                    } else if (value == 'delete') {
                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(product.id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product deleted!')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await checkAndNavigateToAddPage(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }

  /// التحقق من تسجيل الدخول قبل فتح صفحة التعديل
  Future<void> checkAndNavigateToEditPage(BuildContext context, Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // المستخدم غير مسجل
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to edit products.')),
      );
    } else {
      // المستخدم مسجل، الانتقال إلى صفحة التعديل
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductPage(product: product),
        ),
      );
    }
  }

  /// التحقق من تسجيل الدخول قبل فتح صفحة إضافة منتج
  Future<void> checkAndNavigateToAddPage(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to add products.')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddProductPage()),
      );
    }
  }
}

class ProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
UserAccountsDrawerHeader(

  accountEmail: Text(user?.email ?? 'Not logged in'),
  decoration: BoxDecoration(
    color: Colors.blue, // يمكنك تعديل اللون هنا
  ), accountName: null,
),

          ListTile(
            leading: Icon(Icons.login),
            title: Text(user == null ? 'Log In' : 'Log Out'),
            onTap: () async {
              if (user == null) {
                // الانتقال إلى صفحة تسجيل الدخول
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } else {
                // تسجيل الخروج
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully')),
                );
                Navigator.pop(context); // إغلاق Drawer
              }
            },
          ),
        ],
      ),
    );
  }
}
