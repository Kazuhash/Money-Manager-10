class MoneyWallet {
  const MoneyWallet({
    required this.id,
    required this.name,
    this.openingBalance = 0,
  });

  static const defaultId = 'cash';
  static const defaultWallet = MoneyWallet(id: defaultId, name: 'Cash');

  final String id;
  final String name;
  final double openingBalance;

  Map<String, Object> toJson() => {
    'id': id,
    'name': name,
    'openingBalance': openingBalance,
  };

  factory MoneyWallet.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final openingBalance = json['openingBalance'] ?? 0;
    if (id is! String ||
        id.trim().isEmpty ||
        name is! String ||
        name.trim().isEmpty ||
        openingBalance is! num ||
        !openingBalance.toDouble().isFinite) {
      throw const FormatException('Saved wallet is invalid.');
    }
    return MoneyWallet(
      id: id,
      name: name,
      openingBalance: openingBalance.toDouble(),
    );
  }
}
