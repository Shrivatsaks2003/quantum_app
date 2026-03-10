import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class BackendConfigScreen extends StatefulWidget {
  const BackendConfigScreen({super.key});

  @override
  State<BackendConfigScreen> createState() => _BackendConfigScreenState();
}

class _BackendConfigScreenState extends State<BackendConfigScreen> {
  void continueToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    ApiService.loadSavedBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Backend Configuration")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Backend Ready",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "This app is already configured to use your deployed backend.",
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: continueToHome,
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
