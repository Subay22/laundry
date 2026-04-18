import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffDashboardView extends StatelessWidget {
  const StaffDashboardView({super.key});

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
                    'Dashboard',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                  Text(
                    'Rabu, 25 Okt 2023',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Content
          if (isMobile)
            const Column(
              children: [
                _StatsColumn(),
                SizedBox(height: 24),
                _OrderForm(),
              ],
            )
          else
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _StatsColumn()),
                SizedBox(width: 32),
                Expanded(flex: 2, child: _OrderForm()),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatsColumn extends StatelessWidget {
  const _StatsColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _StatCard(
          title: 'PENDAPATAN BULAN INI',
          count: 'Rp 12,500K',
          subtitle: 'Total dari 194 transaksi',
          icon: Icons.payments_outlined,
          bgColor: Color(0xFFF3E5F5),
          iconColor: Color(0xFF6200EE),
        ),
        SizedBox(height: 24),
        _StatCard(
          title: 'SEDANG DIPROSES',
          count: '12',
          subtitle: 'Pesanan Diproses',
          icon: Icons.sync,
          bgColor: Color(0xFFFFFAEE),
          iconColor: Color(0xFFCC8E35),
        ),
        SizedBox(height: 24),
        _StatCard(
          title: 'SIAP DIAMBIL',
          count: '28',
          subtitle: 'Sudah Selesai',
          icon: Icons.check_circle_outline,
          bgColor: Color(0xFFF0F7FF),
          iconColor: Color(0xFF1E88E5),
        ),
        SizedBox(height: 24),
        _StatCard(
          title: 'DIARSIPKAN',
          count: '154',
          subtitle: 'Sudah Diambil',
          icon: Icons.inventory_2_outlined,
          bgColor: Color(0xFFF0FFF4),
          iconColor: Color(0xFF2E7D32),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.count,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: bgColor.withAlpha(100),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderForm extends StatelessWidget {
  const _OrderForm();

  @override
  Widget build(BuildContext context) {
    final bool isSmallWidth = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.all(isSmallWidth ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E88E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Input Pesanan Baru',
                    style: TextStyle(fontSize: isSmallWidth ? 18 : 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (!isSmallWidth)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'TRANS-8829',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          // Stack columns on very small screens
          _ResponsiveRow(
            isSmall: isSmallWidth,
            children: const [
              _FormFieldGroup(
                label: 'TANGGAL & JAM',
                child: _CustomInputField(
                  hint: '25 Oct 2023, 10:45 AM',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              _FormFieldGroup(
                label: 'PIC (LOGIN STAF)',
                child: _CustomInputField(
                  hint: 'Budi Santoso',
                  icon: Icons.badge_outlined,
                  isReadOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ResponsiveRow(
            isSmall: isSmallWidth,
            children: const [
              _FormFieldGroup(
                label: 'NAMA PELANGGAN',
                child: _CustomInputField(
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline,
                ),
              ),
              _FormFieldGroup(
                label: 'NOMOR TELEPON',
                child: _CustomInputField(
                  hint: '0812xxxx',
                  icon: Icons.phone_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ResponsiveRow(
            isSmall: isSmallWidth,
            children: [
              const _FormFieldGroup(
                label: 'TIPE LAUNDRY',
                child: _LaundryTypeDropdown(),
              ),
              const _FormFieldGroup(
                label: 'BERAT (KG)',
                child: _CustomInputField(
                  hint: '0.0',
                  icon: Icons.monitor_weight_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _FormFieldLabel(label: 'ESTIMASI PENGERJAAN'),
          const _CustomInputField(
            hint: 'mm/dd/yyyy',
            icon: Icons.calendar_month_outlined,
          ),
          const SizedBox(height: 24),
          const _FormFieldLabel(label: 'CATATAN'),
          const _CustomInputField(
            hint: 'Contoh: Pisahkan baju putih, noda minyak di kerah',
            maxLines: 3,
          ),
          const SizedBox(height: 32),
          // Total Box
          const _TotalBiayaBox(),
          const SizedBox(height: 32),
          // Buttons
          _ActionButtons(isSmall: isSmallWidth),
        ],
      ),
    );
  }
}

class _ResponsiveRow extends StatelessWidget {
  final bool isSmall;
  final List<Widget> children;

  const _ResponsiveRow({required this.isSmall, required this.children});

  @override
  Widget build(BuildContext context) {
    if (isSmall) {
      return Column(
        children: children
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: EdgeInsets.only(bottom: e.key == children.length - 1 ? 0 : 20.0),
                  child: e.value,
                ))
            .toList(),
      );
    }
    return Row(
      children: children
          .map((e) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: e,
                ),
              ))
          .toList(),
    );
  }
}

class _FormFieldGroup extends StatelessWidget {
  final String label;
  final Widget child;
  const _FormFieldGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormFieldLabel(label: label),
        child,
      ],
    );
  }
}

class _LaundryTypeDropdown extends StatelessWidget {
  const _LaundryTypeDropdown();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'Biasa',
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'Biasa', child: Text('Biasa')),
            DropdownMenuItem(value: 'Ekspres', child: Text('Ekspres')),
          ],
          onChanged: (v) {},
          icon: const Icon(Icons.expand_more),
        ),
      ),
    );
  }
}

class _TotalBiayaBox extends StatelessWidget {
  const _TotalBiayaBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL BIAYA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E88E5).withAlpha(200),
                  ),
                ),
                const SizedBox(height: 4),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Rp 45.000',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF154360)),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.payments_outlined, color: Colors.grey, size: 32),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isSmall;
  const _ActionButtons({required this.isSmall});

  @override
  Widget build(BuildContext context) {
    if (isSmall) {
      return Column(
        children: [
          _Button(
            label: 'Simpan',
            icon: Icons.save_outlined,
            isPrimary: false,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _Button(
            label: 'Simpan & Cetak Struk',
            icon: Icons.print_outlined,
            isPrimary: true,
            onPressed: () {},
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: _Button(
            label: 'Simpan',
            icon: Icons.save_outlined,
            isPrimary: false,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _Button(
            label: 'Simpan & Cetak Struk',
            icon: Icons.print_outlined,
            isPrimary: true,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _Button({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                side: BorderSide(color: Colors.grey.shade200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
    );
  }
}

class _FormFieldLabel extends StatelessWidget {
  final String label;
  const _FormFieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
      ),
    );
  }
}

class _CustomInputField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final int maxLines;
  final bool isReadOnly;

  const _CustomInputField({
    required this.hint,
    this.icon,
    this.maxLines = 1,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: icon != null ? Icon(icon, size: 18) : null,
        filled: true,
        fillColor: const Color(0xFFF1F4F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
