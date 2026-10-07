const List<String> _namaBulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String labelTanggal(DateTime d, {DateTime? now}) {
  final sekarang = now ?? DateTime.now();
  final tanggal = '${d.day} ${_namaBulan[d.month - 1]} ${d.year}';

  if (isSameDay(d, sekarang)) return 'Hari Ini, $tanggal';
  if (isSameDay(d, sekarang.subtract(const Duration(days: 1)))) {
    return 'Kemarin, $tanggal';
  }
  return tanggal;
}