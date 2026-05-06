
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/admin_auth_service.dart';
import '../services/product_firestore_service.dart';
import 'product_form_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  AdminPanelScreenState createState() => AdminPanelScreenState();
}

class AdminPanelScreenState extends State<AdminPanelScreen> {
  final productService = ProductFirestoreService();
  final authService = AdminAuthService();

  void navigateAndAddProduct() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProductFormScreen()),
    );
  }

  void navigateAndEditProduct(Product product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: productService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Actions')),
              ],
              rows: products.map((product) {
                return DataRow(
                  cells: [
                    DataCell(SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(product.imageUrl, fit: BoxFit.cover),
                    )),
                    DataCell(Text(product.name)),
                    DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => navigateAndEditProduct(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => productService.deleteProduct(product.id),
                        ),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateAndAddProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
