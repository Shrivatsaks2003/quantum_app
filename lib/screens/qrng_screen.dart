import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class QRNGScreen extends StatefulWidget {
  const QRNGScreen({super.key});

  @override
  State<QRNGScreen> createState() => _QRNGScreenState();
}

class _QRNGScreenState extends State<QRNGScreen> {
  int bits = 8;
  List<dynamic>? randomBits;
  bool loading = false;

  Future<void> runQRNG() async {
    setState(() => loading = true);

    try {
      final data = await ApiService.qrng(bits);
      setState(() {
        randomBits = data["random_bits"];
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loading = false);
  }

  int countBits(String bit) {
    if (randomBits == null) return 0;
    return randomBits!.where((b) => b.toString() == bit).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quantum Random Number Generator")),
      body: SingleChildScrollView( // ✅ IMPORTANT
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Explanation
            const Text(
              "Explanation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "A Quantum Random Number Generator (QRNG) uses the intrinsic "
              "randomness of quantum measurement. A qubit is placed into a "
              "superposition state and measured repeatedly.\n\n"
              "Each measurement produces a truly random 0 or 1, which cannot "
              "be predicted by any classical algorithm.",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 25),

            /// 🔹 Controls
            Text("Number of bits: $bits", style: const TextStyle(fontSize: 18)),
            Slider(
              min: 1,
              max: 32,
              divisions: 31,
              value: bits.toDouble(),
              onChanged: (val) {
                setState(() => bits = val.toInt());
              },
            ),

            Center(
              child: ElevatedButton(
                onPressed: loading ? null : runQRNG,
                child: const Text("Generate"),
              ),
            ),

            const SizedBox(height: 20),

            if (loading)
              const Center(child: CircularProgressIndicator()),

            /// 🔹 Output
            if (randomBits != null) ...[
              const SizedBox(height: 30),

              const Text(
                "Generated Bit Sequence",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                children: randomBits!
                    .map((bit) => Chip(label: Text(bit.toString())))
                    .toList(),
              ),

              const SizedBox(height: 30),

              /// 🔹 Distribution Chart
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: countBits("0").toDouble(),
                            width: 40,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: countBits("1").toDouble(),
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
                            if (value == 0) return const Text("|0⟩");
                            if (value == 1) return const Text("|1⟩");
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
