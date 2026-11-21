import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final AuthService _auth = AuthService();
  double _selectedAmount = 20000.0;
  String _selectedMethod = 'QRIS Polinela';

  final List<double> _nominalList = [10000, 20000, 50000, 100000];

  final List<Map<String, dynamic>> _methods = [
    {
      'name': 'QRIS Polinela',
      'desc': 'Scan langsung via m-Banking atau e-Wallet',
      'icon': Icons.qr_code_scanner_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'name': 'Transfer Bank (VA BCA / Mandiri / BRI)',
      'desc': 'Nomor Virtual Account Mahasiswa',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Kasir / Loket Kampus Polinela',
      'desc': 'Bayar tunai di kantin pusat atau kasir BAAK',
      'icon': Icons.storefront_rounded,
      'color': Color(0xFFF59E0B),
    },
  ];

  void _handleTopUp() {
    _auth.topUpBalance(_selectedAmount);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Top Up Berhasil! Saldo ditambah ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(_selectedAmount)}'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final curFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Isi Ulang Saldo PoliPay', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0284C7).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saldo PoliPay Saat Ini', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        curFormat.format(_auth.currentUser?.balance ?? 0),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 36),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Pilih Nominal Top Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemCount: _nominalList.length,
              itemBuilder: (context, index) {
                final nominal = _nominalList[index];
                final isSelected = _selectedAmount == nominal;
                return InkWell(
                  onTap: () => setState(() => _selectedAmount = nominal),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE0F2FE) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        curFormat.format(nominal),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            const Text('Metode Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 12),
            ...List.generate(_methods.length, (idx) {
              final m = _methods[idx];
              final isSel = _selectedMethod == m['name'];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isSel ? const Color(0xFFF0FDF4) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSel ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                    width: isSel ? 1.5 : 1,
                  ),
                ),
                child: ListTile(
                  onTap: () => setState(() => _selectedMethod = m['name']),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: (m['color'] as Color).withOpacity(0.12), shape: BoxShape.circle),
                    child: Icon(m['icon'], color: m['color'], size: 22),
                  ),
                  title: Text(m['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  subtitle: Text(m['desc'], style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  trailing: isSel ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)) : null,
                ),
              );
            }),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _handleTopUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Lanjutkan Top Up ${curFormat.format(_selectedAmount)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
