import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PesananView extends StatelessWidget {
  const PesananView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Pesanan',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola dan pantau semua transaksi laundry Anda di sini.',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'Halaman Pesanan Sedang Dikembangkan',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
