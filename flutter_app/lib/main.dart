/// File: main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/product_provider.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/AddScreen.dart';
import 'Screens/productDetail.dart';
import 'Screens/EditScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/add': (ctx) => const AddProductScreen(),
        '/detail': (ctx) => const ProductDetailScreen(),
        '/edit': (ctx) => const EditProductScreen(),
      },
    );
  }
}
