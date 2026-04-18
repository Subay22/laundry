import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String activeLabel;
  final Function(String) onItemSelected;

  const Sidebar({
    super.key,
    required this.activeLabel,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Portal Staf',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 40),
          // Nav Items
          NavItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            isActive: activeLabel == 'Dashboard',
            onTap: () => onItemSelected('Dashboard'),
          ),
          NavItem(
            icon: Icons.shopping_bag_outlined,
            label: 'Pesanan',
            isActive: activeLabel == 'Pesanan',
            onTap: () => onItemSelected('Pesanan'),
          ),
          NavItem(
            icon: Icons.qr_code_scanner,
            label: 'Scan Barcode',
            isActive: activeLabel == 'Scan Barcode',
            onTap: () => onItemSelected('Scan Barcode'),
          ),
          const Spacer(),
          // Shift Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.support_agent, color: Color(0xFF1E88E5), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dukungan Siap',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
                      ),
                      Text(
                        'Pemimpin Shift: Hendra',
                        style: TextStyle(fontSize: 10, color: Color(0xFF607D8B)),
                      ),
                    ],
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

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2962FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey.shade600,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
