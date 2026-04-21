import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';
import '../models/app_data.dart';
import 'staff_dashboard_view.dart';
import 'scan_barcode_view.dart';
import 'pesanan_view.dart';

class StaffShell extends StatefulWidget {
  final AppState appState;

  const StaffShell({super.key, required this.appState});

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

  void _refresh() => setState(() {});

  Widget _buildBody() {
    switch (_activeLabel) {
      case 'Dashboard':
        return StaffDashboardView(appState: widget.appState, onRefresh: _refresh);
      case 'Pesanan':
        return PesananView(appState: widget.appState, onRefresh: _refresh);
      case 'Scan Barcode':
        return ScanBarcodeView(appState: widget.appState, onRefresh: _refresh);
      default:
        return StaffDashboardView(appState: widget.appState, onRefresh: _refresh);
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
