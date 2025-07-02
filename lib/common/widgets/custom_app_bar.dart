import 'package:flutter/material.dart';
import 'package:group_3/features/auth/screens/login_screen.dart';
import 'package:group_3/features/auth/services/auth_service.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogout;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLogout = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      bottom: bottom,
      actions: [
        if (showLogout)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Call logout from AuthService
              Provider.of<AuthService>(context, listen: false).signOut();
              // Navigate back to login screen after logout
              Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName,
                (Route<dynamic> route) => false,
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}