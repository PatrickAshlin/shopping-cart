import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/shopping_cart_screen.dart';
import '../providers/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ShoppingCartScreen(),
      ),
    );
  }
}
