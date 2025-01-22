import 'package:flutter/material.dart';

class PopularProductsList extends StatelessWidget {
  const PopularProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            const Text(
              'Popular Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Responsive Product List using ListView.separated for better UI
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: _buildProductIcon(product['icon']),
                  title: Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    product['price'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a custom product icon
  Widget _buildProductIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: Colors.blue.shade100,
      child: Icon(
        icon,
        color: Colors.blue.shade600,
      ),
    );
  }
}

// Sample Product Data
final List<Map<String, dynamic>> _products = [
  {
    'icon': Icons.fastfood,
    'name': 'Burger',
    'price': '\$2,453.00',
  },
  {
    'icon': Icons.coffee,
    'name': 'Ethiopian Coffee',
    'price': '\$105.60',
  },
  {
    'icon': Icons.restaurant,
    'name': 'Ethiopian Kitfo',
    'price': '\$448.60',
  },
];
