import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';
import 'staff_dashboard_view.dart';
import 'scan_barcode_view.dart';
import 'pesanan_view.dart';

class StaffShell extends StatefulWidget {
  const StaffShell({super.key});

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  String _activeLabel = 'Dashboard';

  void _onItemSelected(String label) {
    if (label == _activeLabel) return;
    setState(() {
      _activeLabel = label;
    });
    
    // Close drawer on mobile after selection
    if (MediaQuery.of(context).size.width < 900) {
      Navigator.pop(context);
    }
  }

  Widget _buildBody() {
    switch (_activeLabel) {
      case 'Dashboard':
        return const StaffDashboardView();
      case 'Pesanan':
        return const PesananView();
      case 'Scan Barcode':
        return const ScanBarcodeView();
      default:
        return const StaffDashboardView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeLabel: _activeLabel,
      onItemSelected: _onItemSelected,
      child: _buildBody(),
    );
  }
}
