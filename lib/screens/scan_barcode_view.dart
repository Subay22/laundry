import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanBarcodeView extends StatefulWidget {
  const ScanBarcodeView({super.key});

  @override
  State<ScanBarcodeView> createState() => _ScanBarcodeViewState();
}

class _ScanBarcodeViewState extends State<ScanBarcodeView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barcode Workflow',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                  Text(
                    'Scanning Station Alpha',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              if (!isMobile)
                Row(
                  children: [
                    Icon(Icons.notifications_none, color: Colors.grey.shade600),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.sync, size: 16, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Live System', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Main Content Row
          if (isMobile)
            Column(
              children: [
                _buildViewfinder(),
                const SizedBox(height: 24),
                _buildStatusText(),
                const SizedBox(height: 24),
                _buildActionCards(),
                const SizedBox(height: 24),
                _buildRecentScans(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Section: Viewfinder + Actions
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildViewfinder(),
                      const SizedBox(height: 32),
                      _buildStatusText(),
                      const SizedBox(height: 40),
                      _buildActionCards(),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Right Section: Recent Scans
                const Expanded(
                  flex: 1,
                  child: _RecentScansSection(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildViewfinder() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C1E),
        borderRadius: BorderRadius.circular(40),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1517677129300-07b130802f46?auto=format&fit=crop&w=800'),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Stack(
        children: [
          // RED LINE ANIMATION
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: 50 + (300 * _controller.value),
                left: 40,
                right: 40,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withAlpha(150),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Viewport Focus Area
          Center(
            child: Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Status Badge
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'LIVE VIEWFINDER',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText() {
    return Column(
      children: [
        Text(
          'Scan Barcode untuk Update Status',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Arahkan kamera ke label barcode pada kantong laundry atau pakaian',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return const IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ActionCard(
              title: 'Scan 1: Mark as Selesai',
              subtitle: 'Pindahkan ke rak pengambilan',
              icon: Icons.assignment_turned_in_outlined,
              color: Color(0xFF0D47A1),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _ActionCard(
              title: 'Scan 2: Check-out',
              subtitle: 'Customer mengambil pesanan',
              icon: Icons.shopping_basket_outlined,
              color: Color(0xFF004D40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScans() {
    return const _RecentScansSection();
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _RecentScansSection extends StatelessWidget {
  const _RecentScansSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: Colors.blue.shade800, size: 20),
                  const SizedBox(width: 12),
                  const Text('Recent Scans', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const Text('TOTAL TODAY: 142', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          _RecentItem(id: '#ORD-99210', name: 'Antoni S. • 4 Items', time: 'Today, 14:02', status: 'SELESAI', statusColor: Colors.blue.shade100, textColor: Colors.blue.shade800),
          _RecentItem(id: '#ORD-99188', name: 'Budi H. • 2 Items', time: 'Today, 13:45', status: 'CHECK-OUT', statusColor: Colors.green.shade100, textColor: Colors.green.shade800),
          _RecentItem(id: '#ORD-99175', name: 'Siska M. • 12 Items', time: 'Today, 13:22', status: 'SELESAI', statusColor: Colors.blue.shade100, textColor: Colors.blue.shade800),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View All Recent Activity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final String id;
  final String name;
  final String time;
  final String status;
  final Color statusColor;
  final Color textColor;

  const _RecentItem({
    required this.id,
    required this.name,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.qr_code_2, size: 24, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(name, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textColor)),
              ),
              const SizedBox(height: 4),
              Text(time, style: TextStyle(fontSize: 9, color: Colors.grey.shade400)),
            ],
          ),
        ],
      ),
    );
  }
}
