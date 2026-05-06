
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/product_firestore_service.dart';
import '../services/product_storage_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  ProductFormScreenState createState() => ProductFormScreenState();
}

class ProductFormScreenState extends State<ProductFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final firestoreService = ProductFirestoreService();
  final storageService = ProductStorageService();

  XFile? imageFile;
  String? imageUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product!.name;
      priceController.text = widget.product!.price.toString();
      imageUrl = widget.product!.imageUrl;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await storageService.pickImage();
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  Future<void> saveProduct() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String? uploadedImageUrl = imageUrl;
      if (imageFile != null) {
        uploadedImageUrl = await storageService.uploadImage(imageFile!); 
      }

      if (!mounted) return;

      if (uploadedImageUrl == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image. Please try again.')),
        );
        return;
      }

      final product = Product(
        id: widget.product?.id ?? '', // Firestore will generate if empty
        name: nameController.text,
        price: double.parse(priceController.text),
        imageUrl: uploadedImageUrl,
      );

      if (widget.product == null) {
        await firestoreService.addProduct(product);
      } else {
        await firestoreService.updateProduct(product);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Product Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter a price';
                        if (double.tryParse(value) == null) return 'Please enter a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buildImagePicker(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveProduct,
                      child: const Text('Save Product'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildImagePicker() {
    return Column(
      children: [
        if (imageFile != null)
          Image.file(
            File(imageFile!.path),
            height: 150,
          )
        else if (imageUrl != null)
          Image.network(
            imageUrl!,
            height: 150,
          ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Select Image'),
          onPressed: pickImage,
        ),
      ],
    );
  }
}
