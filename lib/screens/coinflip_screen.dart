import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> {
  int shots = 10;
  Map<String, dynamic>? result;
  bool loading = false;

  Future<void> runExperiment() async {
    setState(() => loading = true);

    try {
      final data = await ApiService.coinFlip(shots);
      setState(() {
        result = data;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quantum Coin Flip")),
      body: SingleChildScrollView( // ✅ IMPORTANT FIX
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Explanation Section
            const Text(
              "Explanation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "A quantum coin flip uses a Hadamard gate to place a qubit "
              "into a superposition of |0⟩ and |1⟩. When measured, the qubit "
              "collapses randomly, producing a truly random result.\n\n"
              "Unlike a classical coin or software RNG, this randomness "
              "comes from quantum mechanics itself.",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 25),

            /// 🔹 Controls
            Text("Shots: $shots", style: const TextStyle(fontSize: 18)),
            Slider(
              min: 1,
              max: 100,
              divisions: 99,
              value: shots.toDouble(),
              onChanged: (val) {
                setState(() => shots = val.toInt());
              },
            ),

            Center(
              child: ElevatedButton(
                onPressed: loading ? null : runExperiment,
                child: const Text("Run Experiment"),
              ),
            ),

            const SizedBox(height: 20),

            if (loading)
              const Center(child: CircularProgressIndicator()),

            /// 🔹 Result Chart
            if (result != null) ...[
              const SizedBox(height: 30),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: (result!['0'] ?? 0).toDouble(),
                            width: 40,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: (result!['1'] ?? 0).toDouble(),
                            width: 40,
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const Text("Heads |0⟩");
                            if (value == 1) return const Text("Tails |1⟩");
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
