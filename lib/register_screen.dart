import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String _message = '';

  Future<void> _register() async {
    final token = await _authService.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return; // ✅ safe context usage

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        _message = "Registration failed. Please check your details.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _register, child: const Text('Register')),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text("Already have an account? Login"),
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
