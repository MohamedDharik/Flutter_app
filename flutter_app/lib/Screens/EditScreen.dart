import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/product_provider.dart';
import '../Model/Product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late Product product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    product = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).findById(productId);

    _titleController = TextEditingController(text: product.title);
    _descController = TextEditingController(text: product.description);
    _priceController = TextEditingController(text: product.price.toString());
  }

  void _update() {
    if (_formKey.currentState!.validate()) {
      final updated = Product(
        id: product.id,
        title: _titleController.text,
        description: _descController.text,
        price: _priceController.text,
      );
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).updateProduct(product.id, updated);
      Navigator.pop(context);
    }
  }

  void _delete() {
    Provider.of<ProductProvider>(
      context,
      listen: false,
    ).deleteProduct(product.id);
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _update, child: const Text('Update')),
              TextButton(
                onPressed: _delete,
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
