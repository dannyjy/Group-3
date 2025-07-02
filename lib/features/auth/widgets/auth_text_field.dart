import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: const BorderSide(color: Colors.black38),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: const BorderSide(color: Colors.black38),
        // ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
    );
  }
}
