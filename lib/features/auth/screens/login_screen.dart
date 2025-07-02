import 'package:flutter/material.dart';
import 'package:group_3/features/auth/screens/signup_screen.dart';
import 'package:group_3/features/auth/services/auth_service.dart';
import 'package:group_3/features/auth/widgets/auth_text_field.dart';
import 'package:group_3/features/product/screens/product_list_screen.dart';
import 'package:group_3/common/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    final authService = Provider.of<AuthService>(context, listen: false);
    String result = await authService.signInUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });

    if (result == 'success') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        ProductListScreen.routeName,
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              AuthTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              AuthTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: 'Login',
                      onPressed: _loginUser,
                    ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}