import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              product.image,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Center(
                  child: Icon(Icons.smartphone, size: 80, color: Colors.grey),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.price.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.grey),
                ),

                Container(
                  width: 38,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: onAdd,
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
