import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: const Center(
        child: Text(
          "Aquí va el login",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}