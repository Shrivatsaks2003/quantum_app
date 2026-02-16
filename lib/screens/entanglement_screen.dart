import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class EntanglementScreen extends StatefulWidget {
  const EntanglementScreen({super.key});

  @override
  State<EntanglementScreen> createState() => _EntanglementScreenState();
}

class _EntanglementScreenState extends State<EntanglementScreen> {
  int shots = 100;
  bool loading = false;
  Map<String, dynamic>? result;

  Future<void> runExperiment() async {
    setState(() => loading = true);
    final data = await ApiService.entanglement(shots);
    setState(() {
      result = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quantum Entanglement")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Circuit Diagram
            const Text(
              "Quantum Circuit",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.asset(
                "assets/entanglement_circuit.png",
                height: 150,
              ),
            ),

            const SizedBox(height: 15),

            /// 🔹 Explanation
            const Text(
              "Explanation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "A Hadamard gate puts the first qubit into superposition. "
              "A CNOT gate then entangles the second qubit with the first, "
              "creating the Bell state (|00⟩ + |11⟩)/√2.\n\n"
              "When measured, both qubits collapse together, producing only "
              "00 or 11 outcomes.",
            ),

            const SizedBox(height: 25),

            /// 🔹 Controls
            Text("Shots: $shots", style: const TextStyle(fontSize: 18)),
            Slider(
              min: 10,
              max: 500,
              divisions: 49,
              value: shots.toDouble(),
              onChanged: (v) => setState(() => shots = v.toInt()),
            ),

            Center(
              child: ElevatedButton(
                onPressed: loading ? null : runExperiment,
                child: const Text("Run Experiment"),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔹 Output
            if (loading) const Center(child: CircularProgressIndicator()),

            if (result != null) ...[
              const Text(
                "Measurement Results",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: (result!['00'] ?? 0).toDouble(),
                            width: 40,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: (result!['11'] ?? 0).toDouble(),
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
                            if (value == 0) return const Text("00");
                            if (value == 1) return const Text("11");
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
