import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:excel/excel.dart' as xl;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  String _selectedRange = 'Bulan Ini';
  bool _isExporting = false;

  // Financial data
  final double _totalIncome = 42800000;
  final double _operationalCost = 18500000;
  double get _netProfit => _totalIncome - _operationalCost;
  double get _profitMargin => (_netProfit / _totalIncome) * 100;

  // Monthly breakdown
  final List<Map<String, dynamic>> _monthlyData = [
    {'month': 'Jan', 'income': 18.0, 'expense': 8.0},
    {'month': 'Feb', 'income': 22.5, 'expense': 9.5},
    {'month': 'Mar', 'income': 19.8, 'expense': 8.8},
    {'month': 'Apr', 'income': 28.5, 'expense': 12.0},
  ];

  // Transaction data
  final List<Map<String, dynamic>> _transactions = [
    {'id': 'LF-98231-X', 'customer': 'Budi Santoso', 'service': 'Express', 'weight': 3.5, 'price': 52500, 'status': 'Diproses', 'date': '2026-04-17', 'pic': 'Sarah Jenkins'},
    {'id': 'LF-77210-B', 'customer': 'Anita Wijaya', 'service': 'Regular', 'weight': 5.0, 'price': 50000, 'status': 'Selesai', 'date': '2026-04-16', 'pic': 'Marcus Chen'},
    {'id': 'LF-55421-Z', 'customer': 'Rian Pratama', 'service': 'Dry Clean', 'weight': 2.0, 'price': 60000, 'status': 'Diambil', 'date': '2026-04-16', 'pic': 'Sarah Jenkins'},
    {'id': 'LF-44102-A', 'customer': 'Dewi Lestari', 'service': 'Express', 'weight': 4.0, 'price': 60000, 'status': 'Selesai', 'date': '2026-04-15', 'pic': 'David Miller'},
    {'id': 'LF-33891-C', 'customer': 'Ahmad Fauzi', 'service': 'Regular', 'weight': 7.5, 'price': 75000, 'status': 'Diambil', 'date': '2026-04-15', 'pic': 'Elena Rodriguez'},
    {'id': 'LF-22780-D', 'customer': 'Siti Rahayu', 'service': 'Premium', 'weight': 3.0, 'price': 90000, 'status': 'Selesai', 'date': '2026-04-14', 'pic': 'Marcus Chen'},
  ];

  String _fmt(double v) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(v);

  // ==================== EXPORT EXCEL ====================
  Future<void> _exportExcel() async {
    setState(() => _isExporting = true);
    try {
      final excel = xl.Excel.createExcel();
      final sheet = excel['Laporan Keuangan'];
      excel.delete('Sheet1');

      final hStyle = xl.CellStyle(bold: true, backgroundColorHex: xl.ExcelColor.fromHexString('#0D47A1'), fontColorHex: xl.ExcelColor.fromHexString('#FFFFFF'), fontSize: 12);

      sheet.cell(xl.CellIndex.indexByString('A1')).value = xl.TextCellValue('LAPORAN KEUANGAN LAUNDRYFLOW');
      sheet.cell(xl.CellIndex.indexByString('A1')).cellStyle = xl.CellStyle(bold: true, fontSize: 16);
      sheet.merge(xl.CellIndex.indexByString('A1'), xl.CellIndex.indexByString('H1'));
      sheet.cell(xl.CellIndex.indexByString('A2')).value = xl.TextCellValue('Periode: $_selectedRange | Dicetak: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())}');

      sheet.cell(xl.CellIndex.indexByString('A4')).value = xl.TextCellValue('LABA RUGI');
      sheet.cell(xl.CellIndex.indexByString('A4')).cellStyle = xl.CellStyle(bold: true, fontSize: 13);
      sheet.cell(xl.CellIndex.indexByString('A5')).value = xl.TextCellValue('Total Pemasukan:');
      sheet.cell(xl.CellIndex.indexByString('B5')).value = xl.TextCellValue(_fmt(_totalIncome));
      sheet.cell(xl.CellIndex.indexByString('A6')).value = xl.TextCellValue('Biaya Operasional:');
      sheet.cell(xl.CellIndex.indexByString('B6')).value = xl.TextCellValue(_fmt(_operationalCost));
      sheet.cell(xl.CellIndex.indexByString('A7')).value = xl.TextCellValue('Laba Bersih:');
      sheet.cell(xl.CellIndex.indexByString('B7')).value = xl.TextCellValue(_fmt(_netProfit));
      sheet.cell(xl.CellIndex.indexByString('A7')).cellStyle = xl.CellStyle(bold: true);

      final headers = ['No', 'Barcode', 'Customer', 'Layanan', 'Berat', 'Harga', 'Status', 'PIC'];
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 9)).value = xl.TextCellValue(headers[i]);
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 9)).cellStyle = hStyle;
      }
      for (int i = 0; i < _transactions.length; i++) {
        final t = _transactions[i]; final r = 10 + i;
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: r)).value = xl.IntCellValue(i + 1);
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: r)).value = xl.TextCellValue(t['id']);
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: r)).value = xl.TextCellValue(t['customer']);
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: r)).value = xl.TextCellValue(t['service']);
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: r)).value = xl.DoubleCellValue(t['weight']);
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: r)).value = xl.TextCellValue(_fmt((t['price'] as int).toDouble()));
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: r)).value = xl.TextCellValue(t['status']);
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: r)).value = xl.TextCellValue(t['pic']);
      }

      final bytes = excel.save();
      if (bytes == null) throw Exception('Failed');
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/LaundryFlow_Finance_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.xlsx';
      await File(path).writeAsBytes(bytes, flush: true);
      await OpenFile.open(path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Excel berhasil diekspor!', style: GoogleFonts.inter()), backgroundColor: const Color(0xFF2E7D32), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), margin: const EdgeInsets.all(16)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating, margin: const EdgeInsets.all(16)));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  // ==================== EXPORT PDF ====================
  Future<void> _exportPdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (ctx) => [
        pw.Header(level: 0, child: pw.Text('Laporan Keuangan LaundryFlow', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold))),
        pw.Text('Periode: $_selectedRange | Dicetak: ${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(DateTime.now())}'),
        pw.SizedBox(height: 20),
        pw.Text('LABA RUGI', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Keterangan', 'Jumlah'],
          data: [
            ['Total Pemasukan', _fmt(_totalIncome)],
            ['Biaya Operasional', _fmt(_operationalCost)],
            ['Laba Bersih', _fmt(_netProfit)],
            ['Margin Keuntungan', '${_profitMargin.toStringAsFixed(1)}%'],
          ],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellAlignment: pw.Alignment.centerLeft,
        ),
        pw.SizedBox(height: 24),
        pw.Text('RINCIAN TRANSAKSI', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['No', 'ID', 'Customer', 'Layanan', 'Berat', 'Harga', 'Status'],
          data: _transactions.asMap().entries.map((e) {
            final t = e.value;
            return ['${e.key + 1}', t['id'], t['customer'], t['service'], '${t['weight']}kg', _fmt((t['price'] as int).toDouble()), t['status']];
          }).toList(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
          cellStyle: const pw.TextStyle(fontSize: 8),
          cellAlignment: pw.Alignment.centerLeft,
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        _buildHeader(isPhone),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isPhone ? 20.0 : 32.0, vertical: 24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Laporan Keuangan', style: GoogleFonts.inter(fontSize: isPhone ? 22 : 26, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E))),
                    Text('Analisis laba rugi dan rincian transaksi.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500)),
                    const SizedBox(height: 24),
                    _buildPeriodFilter(),
                    const SizedBox(height: 24),

                    // P&L Cards
                    _buildPnLCards(isPhone),
                    const SizedBox(height: 24),

                    // Bar Chart
                    _buildBarChart(isPhone),
                    const SizedBox(height: 32),

                    // Export Buttons
                    _buildExportButtons(),
                    const SizedBox(height: 32),

                    // Transaction List
                    Text('Rincian Transaksi', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E))),
                    const SizedBox(height: 16),
                    ..._transactions.asMap().entries.map((e) => _TransactionCard(index: e.key + 1, data: e.value, fmt: _fmt)),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isPhone) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, isPhone ? 52 : 60, 24, 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const CircleAvatar(radius: 22, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin')),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('LaundryFlow', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0D47A1))),
              Text('ADMIN PORTAL', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.2)),
            ]),
          ]),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
            child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0D47A1), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Tahun Ini'].map((p) {
          bool sel = _selectedRange == p;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedRange = p),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFF0D47A1) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: sel ? null : Border.all(color: Colors.grey.shade200),
                ),
                child: Text(p, style: GoogleFonts.inter(color: sel ? Colors.white : Colors.grey.shade600, fontWeight: sel ? FontWeight.bold : FontWeight.w500, fontSize: 13)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPnLCards(bool isPhone) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: _pnlCard('Total Pemasukan', _fmt(_totalIncome), Icons.trending_up_rounded, const Color(0xFFE8F5E9), const Color(0xFF2E7D32))),
          const SizedBox(width: 12),
          Expanded(child: _pnlCard('Biaya Operasional', _fmt(_operationalCost), Icons.trending_down_rounded, const Color(0xFFFFEBEE), const Color(0xFFD32F2F))),
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1976D2)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: const Color(0xFF0D47A1).withAlpha(60), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('LABA BERSIH', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.1)),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(_fmt(_netProfit), style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                ]),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withAlpha(30), borderRadius: BorderRadius.circular(12)),
                child: Text('${_profitMargin.toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pnlCard(String label, String value, IconData icon, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: fg, size: 20)),
        const SizedBox(height: 14),
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF1A1C2E))),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
      ]),
    );
  }

  Widget _buildBarChart(bool isPhone) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 15, offset: const Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pemasukan vs Pengeluaran', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1C2E))),
          const SizedBox(height: 8),
          Row(children: [
            _legendDot(const Color(0xFF0D47A1), 'Pemasukan'),
            const SizedBox(width: 16),
            _legendDot(const Color(0xFFEF5350), 'Pengeluaran'),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: isPhone ? 180 : 220,
            child: BarChart(BarChartData(
              barTouchData: BarTouchData(enabled: true),
              gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 5, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36, interval: 10, getTitlesWidget: (v, _) => Text('${v.toInt()}M', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade400)))),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                  if (v.toInt() < _monthlyData.length) return Padding(padding: const EdgeInsets.only(top: 8), child: Text(_monthlyData[v.toInt()]['month'], style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)));
                  return const SizedBox.shrink();
                })),
              ),
              barGroups: _monthlyData.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [
                BarChartRodData(toY: e.value['income'], color: const Color(0xFF0D47A1), width: 14, borderRadius: BorderRadius.circular(4)),
                BarChartRodData(toY: e.value['expense'], color: const Color(0xFFEF5350), width: 14, borderRadius: BorderRadius.circular(4)),
              ])).toList(),
            )),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
    ]);
  }

  Widget _buildExportButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isExporting ? null : _exportExcel,
              icon: _isExporting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.table_chart_outlined, size: 20),
              label: Text('Excel', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _exportPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
              label: Text('PDF', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            ),
          ),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  final String Function(double) fmt;

  const _TransactionCard({required this.index, required this.data, required this.fmt});

  Color get _sBg {
    switch (data['status']) { case 'Diproses': return const Color(0xFFFFF3E0); case 'Selesai': return const Color(0xFFE3F2FD); case 'Diambil': return const Color(0xFFE8F5E9); default: return Colors.grey.shade100; }
  }
  Color get _sTxt {
    switch (data['status']) { case 'Diproses': return const Color(0xFFE65100); case 'Selesai': return const Color(0xFF1565C0); case 'Diambil': return const Color(0xFF2E7D32); default: return Colors.grey; }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(10)), child: Text('#$index', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0D47A1)))),
            const SizedBox(width: 12),
            Text(data['id'], style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF1A1C2E))),
          ]),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _sBg, borderRadius: BorderRadius.circular(10)), child: Text((data['status'] as String).toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: _sTxt))),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _i('CUSTOMER', data['customer'])),
          Expanded(child: _i('LAYANAN', data['service'])),
          Expanded(child: _i('HARGA', fmt((data['price'] as int).toDouble()))),
        ]),
      ]),
    );
  }

  Widget _i(String l, String v) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(l, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
    Text(v, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1A1C2E)), overflow: TextOverflow.ellipsis),
  ]);
}
