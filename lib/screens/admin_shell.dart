import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_data.dart';
import 'admin_dashboard_view.dart';
import 'admin_orders_page.dart';
import 'admin_staff_page.dart';
import 'admin_report_page.dart';

class AdminShell extends StatefulWidget {
  final AppState appState;

  const AdminShell({super.key, required this.appState});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = widget.appState;
  }

  void _refresh() => setState(() {});

  void _addOrder(OrderData order) {
    setState(() => _appState.orders.insert(0, order));
  }

  void _deleteOrder(OrderData order) {
    setState(() => _appState.orders.remove(order));
  }

  void _addStaff(StaffData staff) {
    setState(() => _appState.staffList.add(staff));
  }

  void _deleteStaff(StaffData staff) {
    setState(() => _appState.staffList.remove(staff));
  }

  void _updateStaff(StaffData oldStaff, StaffData newStaff) {
    setState(() {
      final idx = _appState.staffList.indexOf(oldStaff);
      if (idx != -1) _appState.staffList[idx] = newStaff;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPhone = screenWidth < 600;

    final List<Widget> pages = [
      AdminDashboardPage(
        appState: _appState,
        onRefresh: _refresh,
      ),
      AdminOrdersPage(
        appState: _appState,
        onAddOrder: _addOrder,
        onRefresh: _refresh,
        onDeleteOrder: _deleteOrder,
      ),
      AdminStaffPage(
        appState: _appState,
        onAddStaff: _addStaff,
        onDeleteStaff: _deleteStaff,
        onUpdateStaff: _updateStaff,
      ),
      AdminReportPage(
        appState: _appState,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          // Floating Bottom Nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(isPhone),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isPhone) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          left: isPhone ? 16 : 24,
          right: isPhone ? 16 : 24,
          bottom: isPhone ? 24 : 32,
        ),
        height: 72,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(245),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(Icons.grid_view_rounded, 'DASHBOARD', 0, isPhone),
            _navItem(Icons.local_laundry_service_outlined, 'ORDERS', 1, isPhone),
            _navItem(Icons.people_outline, 'STAFF', 2, isPhone),
            _navItem(Icons.assessment_outlined, 'REPORTS', 3, isPhone),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, bool isPhone) {
    bool isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFD9E9FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? const Color(0xFF0D47A1) : Colors.grey.shade400,
                  size: isPhone ? 22 : 24,
                ),
              ),
              if (isSelected) const SizedBox(height: 4),
              if (isSelected)
                FittedBox(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
