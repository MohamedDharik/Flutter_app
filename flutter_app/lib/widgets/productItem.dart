import 'package:flutter/material.dart';
import '../Model/Product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for the card
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ), // Adjusted margin
      elevation: 5, // Higher elevation for a more modern look
      shadowColor: Colors.black26, // Lighter shadow color for better visual
      child: InkWell(
        borderRadius: BorderRadius.circular(12), // InkWell with rounded corners
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: product.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(12), // Padding for neat content
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Centered content
            children: [
              // Placeholder for product image (optional, you can skip it)
              Container(
                width: 80,
                height: 80,
                color: Colors.grey[300], // Placeholder color
                child: const Icon(Icons.image, color: Colors.white),
              ),
              const SizedBox(width: 12), // Spacing between image and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 6,
                    ), // Space between title and description
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Price displayed in a separate widget
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '₹${product.price}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
