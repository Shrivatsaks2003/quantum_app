import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class TeleportationScreen extends StatefulWidget {
  const TeleportationScreen({super.key});

  @override
  State<TeleportationScreen> createState() => _TeleportationScreenState();
}

class _TeleportationScreenState extends State<TeleportationScreen> {
  int initialState = 0;
  int shots = 100;
  Map<String, dynamic>? result;
  bool loading = false;

  Future<void> runTeleportation() async {
    setState(() => loading = true);

    try {
      final data =
          await ApiService.teleportation(initialState, shots);
      setState(() => result = data);
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loading = false);
  }

  List<BarChartGroupData> _buildBars() {
    if (result == null) return [];

    final entries = result!.entries.toList();

    return List.generate(entries.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (entries[index].value as num).toDouble(),
            width: 22,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quantum Teleportation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Quantum Circuit
            const Text(
              "Quantum Circuit",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Center(
              child: Image.asset(
                "assets/teleportation.png",
                height: 160,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Explanation
            const Text(
              "Explanation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Text(
              "Quantum teleportation transfers the quantum state of one qubit "
              "to another distant qubit using entanglement and classical communication.\n\n"
              "First, qubits 1 and 2 are entangled. A Bell measurement is performed "
              "on qubits 0 and 1. Based on the measurement results, corrective "
              "operations are applied to qubit 2, recreating the original state.",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 25),

            /// 🔹 Controls
            const Text(
              "Initial State",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            Row(
              children: [
                Radio<int>(
                  value: 0,
                  groupValue: initialState,
                  onChanged: (v) => setState(() => initialState = v!),
                ),
                const Text("|0⟩"),
                Radio<int>(
                  value: 1,
                  groupValue: initialState,
                  onChanged: (v) => setState(() => initialState = v!),
                ),
                const Text("|1⟩"),
              ],
            ),

            Text("Shots: $shots"),
            Slider(
              min: 10,
              max: 200,
              divisions: 19,
              value: shots.toDouble(),
              onChanged: (v) => setState(() => shots = v.toInt()),
            ),

            Center(
              child: ElevatedButton(
                onPressed: loading ? null : runTeleportation,
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
                    barGroups: _buildBars(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final keys = result!.keys.toList();
                            if (value.toInt() < keys.length) {
                              return Text(keys[value.toInt()]);
                            }
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
