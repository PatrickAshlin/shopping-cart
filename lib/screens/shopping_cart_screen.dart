import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import 'cart_screen.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<Product> futureProducts = [];
  int _page = 1;
  final int _limit = 15;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Product> newProducts = await ProductService.fetchProducts(
        page: _page,
        limit: _limit,
      );

      setState(() {
        futureProducts.addAll(newProducts);
        _page++; // Increase the page number
        _isLoading = false;
        if (newProducts.length < _limit) _hasMore = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to the cart screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    cartProvider.cart.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body:
          futureProducts.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                controller: _scrollController,
                itemCount: futureProducts.length + 1,
                itemBuilder: (context, index) {
                  if (index == futureProducts.length) {
                    return _hasMore
                        ? const Center(child: CircularProgressIndicator())
                        : const Center(child: Text("No more products"));
                  }
                  var product = futureProducts[index];

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        product.thumbnail,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(product.title),
                      subtitle: Text(
                        "Original: \$${product.price.toStringAsFixed(2)}\n"
                        "Discounted: \$${product.discountedPrice.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.green),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          cartProvider.addToCart(product);
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
