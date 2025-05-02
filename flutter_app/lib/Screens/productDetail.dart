import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductProvider>(context).findById(productId);

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('₹${product.price}', style: const TextStyle(fontSize: 20)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit', arguments: product.id);
              },
              child: const Text('Edit Product'),
            ),
          ],
        ),
      ),
    );
  }
}
