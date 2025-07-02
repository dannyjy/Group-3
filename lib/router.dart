import 'package:flutter/material.dart';
import 'package:group_3/features/auth/screens/login_screen.dart';
import 'package:group_3/features/auth/screens/signup_screen.dart';
import 'package:group_3/features/product/screens/add_product_screen.dart';
import 'package:group_3/features/product/screens/product_list_screen.dart';
import 'package:group_3/features/product/screens/product_detail_screen.dart';
import 'package:group_3/models/product.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case SignupScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignupScreen());
    case ProductListScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ProductListScreen());
    case AddProductScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AddProductScreen());
    case ProductDetailScreen.routeName:
      final product = settings.arguments as Product?; // Cast arguments to Product
      return MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product));
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Error: Page not found!'),
          ),
        ),
      );
  }
}