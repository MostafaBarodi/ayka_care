import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'voice_call_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _token = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Load the token from SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
    debugPrint('🔐 Token: $token');
  }

  // Logout function
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove token
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ), // Redirect to login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🏠 Home Screen", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text("Token:\n$_token", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final channelName = 'ayka_room1'; // or use token/user id
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoCallScreen(channelName: channelName),
                  ),
                );
              },
              child: const Text("Start Video Call"),
            ),

            ElevatedButton(
              onPressed: _logout, // Trigger logout when pressed
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
