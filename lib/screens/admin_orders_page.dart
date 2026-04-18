import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPhone = screenWidth < 600;

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isPhone ? 20.0 : 32.0,
              vertical: 24.0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildFilterChips(),
                    const SizedBox(height: 32),
                    _buildActiveOrdersHeader(),
                    const SizedBox(height: 16),
                    _buildOrdersList(),
                    const SizedBox(height: 120), // Padding for floating nav
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      color: Colors.white,
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
                      fontSize: 18,
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.qr_code_scanner_rounded, color: Colors.grey.shade400),
          hintText: 'Search barcode or name...',
          hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<String> filters = ['All', 'Diproses', 'Sudah Selesai', 'Sudah Diambil'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          bool isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0D47A1) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                  boxShadow: isSelected ? [
                    BoxShadow(color: const Color(0xFF0D47A1).withAlpha(50), blurRadius: 10, offset: const Offset(0, 4))
                  ] : null,
                ),
                child: Text(
                  filter,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActiveOrdersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Active Orders',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        Text(
          '12 Orders',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D47A1),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList() {
    return Column(
      children: const [
        _OrderCard(
          id: 'LF-98231-X',
          customer: 'Budi Santoso',
          pic: 'Sarah Jenkins',
          status: 'DIPROSES',
          statusColor: Color(0xFFFFF3E0),
          textColor: Color(0xFFE65100),
          showActions: true,
        ),
        _OrderCard(
          id: 'LF-77210-B',
          customer: 'Anita Wijaya',
          pic: 'Marcus Ro',
          status: 'SUDAH SELESAI',
          statusColor: Color(0xFFE3F2FD),
          textColor: Color(0xFF1565C0),
        ),
        _OrderCard(
          id: 'LF-55421-Z',
          customer: 'Rian Pratama',
          pic: 'Sarah Jenkins',
          status: 'SUDAH DIAMBIL',
          statusColor: Color(0xFFE8F5E9),
          textColor: Color(0xFF2E7D32),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String id;
  final String customer;
  final String pic;
  final String status;
  final Color statusColor;
  final Color textColor;
  final bool showActions;

  const _OrderCard({
    required this.id,
    required this.customer,
    required this.pic,
    required this.status,
    required this.statusColor,
    required this.textColor,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BARCODE ID',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    id,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CUSTOMER',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      customer,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PIC STAFF',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      pic,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showActions) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.undo_rounded, size: 18),
                    label: const Text('Cancel Check-out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE9EEF5),
                      foregroundColor: const Color(0xFF1A1C1E),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
