import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body:
          cartProvider.cart.isEmpty
              ? const Center(
                child: Text(
                  "Your cart is empty!",
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.cart.length,
                      itemBuilder: (context, index) {
                        var item = cartProvider.cart[index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              item.thumbnail,
                              width: 50,
                              height: 50,
                            ),
                            title: Text(item.title),
                            subtitle: Text(
                              "\$${item.discountedPrice.toStringAsFixed(2)}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.remove_shopping_cart,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                cartProvider.removeFromCart(item);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Checkout functionality can be added here
                          },
                          child: const Text("Proceed to Checkout"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
