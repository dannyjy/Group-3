import 'package:flutter/material.dart';
import 'package:group_3/router.dart';
import 'package:group_3/features/auth/screens/login_screen.dart';
import 'package:group_3/features/product/screens/product_list_screen.dart';
import 'package:group_3/features/auth/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:group_3/features/product/services/product_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Consumer<AuthService>(
        builder: (context, authService, child) {
          // Check if a user is "logged in" based on our dummy auth service
          return authService.isLoggedIn ? const ProductListScreen() : const LoginScreen();
        },
      ),
    );
  }
}