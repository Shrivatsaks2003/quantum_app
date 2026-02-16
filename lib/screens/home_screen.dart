import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'coinflip_screen.dart';
import 'qrng_screen.dart';
import 'entanglement_screen.dart';
import 'teleportation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool connected = false;

  void connectBackend() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      ApiService.setBaseUrl(url);
      setState(() => connected = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Backend connected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quantum Experiments")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Backend URL Input
            const Text(
              "Backend / ngrok URL",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: "https://xxxxx.ngrok-free.dev",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: connectBackend,
              child: const Text("Connect Backend"),
            ),

            const SizedBox(height: 10),

            if (connected)
              const Text(
                "Connected ✔",
                style: TextStyle(color: Colors.green),
              ),

            const Divider(height: 40),

            /// 🔹 Experiments List
            ExperimentCard(
              title: "Quantum Coin Flip",
              description: "True quantum randomness",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CoinFlipScreen()),
                );
              },
            ),

            ExperimentCard(
              title: "Quantum Random Number Generator",
              description: "Generate true random bits",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRNGScreen()),
                );
              },
            ),

            ExperimentCard(
              title: "Quantum Entanglement",
              description: "Bell state correlation",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const EntanglementScreen()),
                );
              },
            ),

            ExperimentCard(
              title: "Quantum Teleportation",
              description: "Teleport a quantum state",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TeleportationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExperimentCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const ExperimentCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
