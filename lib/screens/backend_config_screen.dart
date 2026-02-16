import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class BackendConfigScreen extends StatefulWidget {
  const BackendConfigScreen({super.key});

  @override
  State<BackendConfigScreen> createState() => _BackendConfigScreenState();
}

class _BackendConfigScreenState extends State<BackendConfigScreen> {
  final TextEditingController _controller = TextEditingController();

  void saveUrl() {
    final url = _controller.text.trim();
    if (url.isNotEmpty) {
      ApiService.setBaseUrl(url);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
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
              "Enter ngrok Backend URL",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Paste the ngrok forwarding URL from your Flask backend.\n"
              "Example:\nhttps://xxxxx.ngrok-free.dev",
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "https://xxxxx.ngrok-free.dev",
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: saveUrl,
                child: const Text("Connect"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
