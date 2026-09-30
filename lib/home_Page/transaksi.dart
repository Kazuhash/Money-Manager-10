enum TipeTransaksi { pemasukan, pengeluaran }

class Transaksi {
  final String judul;
  final double jumlah;
  final TipeTransaksi tipe;
  final DateTime tanggal;

  Transaksi({
    required this.judul,
    required this.jumlah,
    required this.tipe,
    required this.tanggal,
  });
}

String rupiah(double v) {
  final s = v.abs().round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '${v < 0 ? '-' : ''}Rp$buf';
}

String tanggalPendek(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';