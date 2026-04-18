import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String _selectedPeriod = 'Mingguan';

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPhone = screenWidth < 600;


    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isPhone ? 20.0 : 32.0,
          vertical: 24.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                // === SECTION 1: Summary Widgets ===
                _buildSummaryCards(isPhone),
                const SizedBox(height: 32),

                // === SECTION 2: Revenue Trend Chart ===
                _buildChartHeader(),
                const SizedBox(height: 16),
                _buildRevenueChart(isPhone),
                const SizedBox(height: 32),

                // === SECTION 3: Status Pie Chart + Recent Orders ===
                if (isPhone)
                  Column(
                    children: [
                      _buildStatusPieChart(),
                      const SizedBox(height: 24),
                      _buildRecentOrders(),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildStatusPieChart()),
                      const SizedBox(width: 24),
                      Expanded(flex: 3, child: _buildRecentOrders()),
                    ],
                  ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== HEADER ====================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LaundryFlow',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF0D47A1)),
                ),
                Text(
                  'ADMIN PORTAL',
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.2),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white, shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0D47A1), size: 24),
        ),
      ],
    );
  }

  // ==================== SUMMARY CARDS ====================
  Widget _buildSummaryCards(bool isPhone) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _summaryCard('Pendapatan Hari Ini', _formatCurrency(2850000), Icons.account_balance_wallet_outlined, const Color(0xFFE3F2FD), const Color(0xFF1565C0), '+18%')),
            const SizedBox(width: 12),
            Expanded(child: _summaryCard('Pesanan Aktif', '24', Icons.receipt_long_outlined, const Color(0xFFFFF3E0), const Color(0xFFE65100), '+5')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _summaryCard('Backlog', '8', Icons.warning_amber_rounded, const Color(0xFFFFEBEE), const Color(0xFFD32F2F), '-3')),
            const SizedBox(width: 12),
            Expanded(child: _summaryCard('Pelanggan Baru', '5', Icons.person_add_outlined, const Color(0xFFE8F5E9), const Color(0xFF2E7D32), '+2')),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color bgColor, Color iconColor, String badge) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badge.startsWith('+') ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.inter(
                    fontSize: 10, fontWeight: FontWeight.bold,
                    color: badge.startsWith('+') ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(value, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF1A1C2E))),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  // ==================== CHART HEADER ====================
  Widget _buildChartHeader() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Text('Tren Pendapatan', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E))),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ['Mingguan', 'Bulanan'].map((p) {
              bool sel = _selectedPeriod == p;
              return GestureDetector(
                onTap: () => setState(() => _selectedPeriod = p),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFF0D47A1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(p, style: GoogleFonts.inter(fontSize: 12, fontWeight: sel ? FontWeight.bold : FontWeight.w500, color: sel ? Colors.white : Colors.grey.shade600)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ==================== LINE CHART ====================
  Widget _buildRevenueChart(bool isPhone) {
    final weeklyData = [1.2, 1.8, 1.5, 2.1, 2.8, 2.3, 2.85];
    final monthlyData = [18.0, 22.5, 19.8, 24.1, 28.5, 32.0, 26.4, 30.2, 35.1, 38.8, 42.0, 42.8];
    final data = _selectedPeriod == 'Mingguan' ? weeklyData : monthlyData;
    final labels = _selectedPeriod == 'Mingguan'
        ? ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 15, offset: const Offset(0, 6))],
      ),
      child: SizedBox(
        height: isPhone ? 200 : 260,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _selectedPeriod == 'Mingguan' ? 0.5 : 10,
              getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true, reservedSize: 40,
                  interval: _selectedPeriod == 'Mingguan' ? 1 : 10,
                  getTitlesWidget: (v, _) => Text('${v.toInt()}', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade400)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true, reservedSize: 32,
                  interval: 1,
                  getTitlesWidget: (v, _) {
                    int i = v.toInt();
                    if (i >= 0 && i < labels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(labels[i], style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade400)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0, maxX: (data.length - 1).toDouble(),
            minY: 0, maxY: data.reduce((a, b) => a > b ? a : b) * 1.2,
            lineBarsData: [
              LineChartBarData(
                spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                isCurved: true,
                color: const Color(0xFF0D47A1),
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                    radius: 4, color: Colors.white,
                    strokeWidth: 2, strokeColor: const Color(0xFF0D47A1),
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [const Color(0xFF0D47A1).withAlpha(60), const Color(0xFF0D47A1).withAlpha(5)],
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) => spots.map((s) => LineTooltipItem(
                  _selectedPeriod == 'Mingguan' ? _formatCurrency(s.y * 1000000) : _formatCurrency(s.y * 1000000),
                  GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                )).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== PIE CHART ====================
  Widget _buildStatusPieChart() {
    final statusData = [
      {'label': 'Antrian', 'value': 8.0, 'color': const Color(0xFF42A5F5)},
      {'label': 'Proses', 'value': 6.0, 'color': const Color(0xFFFFA726)},
      {'label': 'Pencucian', 'value': 4.0, 'color': const Color(0xFFEF5350)},
      {'label': 'Pengeringan', 'value': 3.0, 'color': const Color(0xFFAB47BC)},
      {'label': 'Siap Ambil', 'value': 3.0, 'color': const Color(0xFF66BB6A)},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 15, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Cucian', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E))),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: statusData.map((d) => PieChartSectionData(
                  value: d['value'] as double,
                  color: d['color'] as Color,
                  radius: 30,
                  showTitle: false,
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...statusData.map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: d['color'] as Color, borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 10),
                Expanded(child: Text(d['label'] as String, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600))),
                Text('${(d['value'] as double).toInt()}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ==================== RECENT ORDERS ====================
  Widget _buildRecentOrders() {
    final orders = [
      {'name': 'Amanda Rizky', 'service': 'Express', 'status': 'Pencucian', 'time': '10:45', 'img': 'https://i.pravatar.cc/150?u=1'},
      {'name': 'David Wilson', 'service': 'Regular', 'status': 'Antrian', 'time': '10:12', 'img': 'https://i.pravatar.cc/150?u=2'},
      {'name': 'Sarah Johnson', 'service': 'Dry Clean', 'status': 'Siap Ambil', 'time': '09:55', 'img': 'https://i.pravatar.cc/150?u=3'},
      {'name': 'Michael Tan', 'service': 'Express', 'status': 'Pengeringan', 'time': '09:30', 'img': 'https://i.pravatar.cc/150?u=4'},
    ];

    Color statusColor(String s) {
      switch (s) {
        case 'Antrian': return const Color(0xFF42A5F5);
        case 'Proses': return const Color(0xFFFFA726);
        case 'Pencucian': return const Color(0xFFEF5350);
        case 'Pengeringan': return const Color(0xFFAB47BC);
        case 'Siap Ambil': return const Color(0xFF66BB6A);
        default: return Colors.grey;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 15, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan Terbaru', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E))),
              Text('4 aktif', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0D47A1))),
            ],
          ),
          const SizedBox(height: 16),
          ...orders.map((o) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFDFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(radius: 22, backgroundImage: NetworkImage(o['img']!)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o['name']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E))),
                      Text(o['service']!, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusColor(o['status']!).withAlpha(30), borderRadius: BorderRadius.circular(8)),
                      child: Text(o['status']!, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor(o['status']!))),
                    ),
                    const SizedBox(height: 4),
                    Text(o['time']!, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade400)),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
