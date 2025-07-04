import 'package:flutter/material.dart';
import 'package:group_3/features/auth/screens/login_screen.dart';
import 'package:group_3/features/auth/services/auth_service.dart';
import 'package:group_3/features/auth/widgets/auth_text_field.dart';
import 'package:group_3/common/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup-screen';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signupUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final authService = Provider.of<AuthService>(context, listen: false);
    String result = await authService.signUpUser(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });

    if (result == 'success') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
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
      // appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              AuthTextField(
                controller: _fullNameController,
                hintText: 'Full Name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              AuthTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: 'Sign Up',
                      onPressed: _signupUser,
                    ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to login screen
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
