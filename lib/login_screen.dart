import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String _message = '';

  Future<void> _login() async {
    final token = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        _message = "Login failed. Please check your credentials.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text("Don't have an account? Register"),
            ),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_message, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
