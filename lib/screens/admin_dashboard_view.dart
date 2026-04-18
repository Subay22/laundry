import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String _selectedPeriod = 'Yearly';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPhone = screenWidth < 600;
    final bool isDesktop = screenWidth >= 1024;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isPhone ? 16.0 : 32.0,
          vertical: 24.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildTimeFilters(),
                const SizedBox(height: 32),
                
                // Responsive Stats
                if (isPhone)
                  Column(
                    children: [
                      _buildOrdersStat(isPhone),
                      const SizedBox(height: 24),
                      _buildRevenueStat(isPhone),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildOrdersStat(isPhone)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildRevenueStat(isPhone)),
                    ],
                  ),
                
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Pesanan Terbaru (Staff PIC)',
                        style: GoogleFonts.inter(
                          fontSize: isPhone ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1C2E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF2962FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Responsive List/Grid
                if (isPhone)
                  _buildOrderList()
                else
                  _buildOrderGrid(isDesktop),
                  
                const SizedBox(height: 120), // Padding for floating nav coverage
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
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
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D47A1),
                    ),
                  ),
                  Text(
                    'ADMIN PORTAL',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0D47A1), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilters() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Yearly', 'Monthly', 'Weekly'].map((period) {
          final bool isSelected = _selectedPeriod == period;
          return GestureDetector(
            onTap: () => setState(() => _selectedPeriod = period),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0D47A1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                period,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersStat(bool isPhone) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isPhone ? 32 : 40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isPhone ? 32 : 40),
        child: Stack(
          children: [
            // Decorative circle - large
            Positioned(
              right: isPhone ? -50 : -40,
              bottom: isPhone ? -50 : -40,
              child: Container(
                width: isPhone ? 150 : 190,
                height: isPhone ? 150 : 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0D47A1).withAlpha(12),
                    width: 2,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            // Decorative circle - medium
            Positioned(
              right: isPhone ? -20 : -10,
              bottom: isPhone ? -70 : -60,
              child: Container(
                width: isPhone ? 110 : 140,
                height: isPhone ? 110 : 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0D47A1).withAlpha(10),
                    width: 2,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            // Decorative dot - top right
            Positioned(
              right: isPhone ? -50 : -40,
              top: isPhone ? -30 : -20,
              child: Container(
                width: isPhone ? 100 : 130,
                height: isPhone ? 100 : 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D47A1).withAlpha(6),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(isPhone ? 24 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL PESANAN',
                        style: GoogleFonts.inter(
                          fontSize: isPhone ? 10 : 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up, color: Color(0xFF43A047), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '+12%',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF43A047),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1,284',
                    style: GoogleFonts.inter(
                      fontSize: isPhone ? 40 : 56,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1C2E),
                    ),
                  ),
                  Text(
                    'Orders completed this period',
                    style: GoogleFonts.inter(
                      fontSize: isPhone ? 12 : 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRevenueStat(bool isPhone) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isPhone ? 32 : 40),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withAlpha(100),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isPhone ? 32 : 40),
        child: Stack(
          children: [
            // Decorative circle - large
            Positioned(
              right: isPhone ? -40 : -30,
              bottom: isPhone ? -40 : -30,
              child: Container(
                width: isPhone ? 140 : 180,
                height: isPhone ? 140 : 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(25),
                    width: 2,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            // Decorative circle - medium
            Positioned(
              right: isPhone ? -10 : 0,
              bottom: isPhone ? -60 : -50,
              child: Container(
                width: isPhone ? 100 : 130,
                height: isPhone ? 100 : 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(20),
                    width: 2,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            // Decorative arc - top right
            Positioned(
              right: isPhone ? -60 : -50,
              top: isPhone ? -20 : -10,
              child: Container(
                width: isPhone ? 120 : 150,
                height: isPhone ? 120 : 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(10),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(isPhone ? 24 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL PENDAPATAN',
                        style: GoogleFonts.inter(
                          fontSize: isPhone ? 10 : 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withAlpha(180),
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '+8.4%',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Rp ',
                        style: GoogleFonts.inter(
                          fontSize: isPhone ? 18 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '42.8M',
                        style: GoogleFonts.inter(
                          fontSize: isPhone ? 36 : 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, color: Colors.white.withAlpha(200), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Net revenue after tax',
                        style: GoogleFonts.inter(
                          fontSize: isPhone ? 12 : 14,
                          color: Colors.white.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildOrderList() {
    return Column(
      children: [
        _OrderTile(name: 'Amanda Rizky', pic: 'Budi Santoso', type: 'Express', time: '10:45 AM', imgUrl: 'https://i.pravatar.cc/150?u=1'),
        _OrderTile(name: 'David Wilson', pic: 'Siti Aminah', type: 'Regular', time: '10:12 AM', imgUrl: 'https://i.pravatar.cc/150?u=2'),
        _OrderTile(name: 'Sarah Johnson', pic: 'Budi Santoso', type: 'Dry Clean', time: '09:55 AM', imgUrl: 'https://i.pravatar.cc/150?u=3'),
        _OrderTile(name: 'Michael Tan', pic: 'Agus Prayoga', type: 'Express', time: '09:30 AM', imgUrl: 'https://i.pravatar.cc/150?u=4'),
        _OrderTile(name: 'Linda Wu', pic: 'Siti Aminah', type: 'Regular', time: '09:15 AM', imgUrl: 'https://i.pravatar.cc/150?u=5'),
      ],
    );
  }

  Widget _buildOrderGrid(bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 3 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isDesktop ? 2.8 : 2.5,
      children: [
        _OrderTile(name: 'Amanda Rizky', pic: 'Budi Santoso', type: 'Express', time: '10:45 AM', imgUrl: 'https://i.pravatar.cc/150?u=1'),
        _OrderTile(name: 'David Wilson', pic: 'Siti Aminah', type: 'Regular', time: '10:12 AM', imgUrl: 'https://i.pravatar.cc/150?u=2'),
        _OrderTile(name: 'Sarah Johnson', pic: 'Budi Santoso', type: 'Dry Clean', time: '09:55 AM', imgUrl: 'https://i.pravatar.cc/150?u=3'),
        _OrderTile(name: 'Michael Tan', pic: 'Agus Prayoga', type: 'Express', time: '09:30 AM', imgUrl: 'https://i.pravatar.cc/150?u=4'),
        _OrderTile(name: 'Linda Wu', pic: 'Siti Aminah', type: 'Regular', time: '09:15 AM', imgUrl: 'https://i.pravatar.cc/150?u=5'),
      ],
    );
  }
}

class _OrderTile extends StatelessWidget {
  final String name;
  final String pic;
  final String type;
  final String time;
  final String imgUrl;

  const _OrderTile({
    required this.name,
    required this.pic,
    required this.type,
    required this.time,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(imgUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      'PIC: $pic',
                      style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                type,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C3E)),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
