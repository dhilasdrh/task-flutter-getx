import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/mahasiswa_model.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Mahasiswa mahasiswa = Get.arguments as Mahasiswa;

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Detail Mahasiswa'),
        title: Image.asset("assets/image/university-logo.png", height: 45, ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF2F6FF),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFFF2F6FF),
          child: mahasiswa == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    mahasiswa.imageUrl ?? 'assets/image/img-placeholder.webp',
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.indigo.shade400, Colors.indigo.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                mahasiswa.nama ?? 'Nama Mahasiswa',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                mahasiswa.nim ?? 'NIM',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Personal Information
              _buildSectionTitle('Personal Information'),
              _buildDetailItem('Email', 'student@mail.com'),
              _buildDetailItem('No. HP', '+6234567890'),
              _buildDetailItem('Alamat', 'Indonesia'),

              // Academic Details
              _buildSectionTitle('Academic Details'),
              _buildDetailItem('Program Studi', mahasiswa.prodi ?? 'Program Studi'),
              _buildDetailItem('Angkatan', mahasiswa.angkatan ?? 'Angkatan'),
              _buildDetailItem('IPK', mahasiswa.ipk ?? 'IPK'),

              // Graph
              _buildSectionTitle('IPK Graph'),
              _buildGpaGraph(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Text(title, style: TextStyle (
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade400
      ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Color(0xff001e61),
                  fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildGpaGraph() {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 16),
      child: LineChart(
        LineChartData(
          maxY: 4,
          minY: 0,
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.black.withOpacity(.2))),
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(),
              isCurved: true,
              color: Colors.indigo.withOpacity(.7),
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.indigo.shade200),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    return [
      const FlSpot(1, 3.35),
      const FlSpot(2, 3.58),
      const FlSpot(3, 3.72),
      const FlSpot(4, 3.40),
      const FlSpot(5, 3.52),
      const FlSpot(6, 3.60),
      const FlSpot(7, 3.88),
    ];
  }


}