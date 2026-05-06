
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'products';

  // Stream of products
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection(_collectionPath)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  // Add a product
  Future<void> addProduct(Product product) {
    return _firestore.collection(_collectionPath).add(product.toMap());
  }

  // Update a product
  Future<void> updateProduct(Product product) {
    return _firestore
        .collection(_collectionPath)
        .doc(product.id)
        .update(product.toMap());
  }

  // Delete a product
  Future<void> deleteProduct(String productId) {
    return _firestore.collection(_collectionPath).doc(productId).delete();
  }
}
