import 'money_wallet.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final bool isIncome;
  final String walletId;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
    this.walletId = MoneyWallet.defaultId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'isIncome': isIncome,
      'walletId': walletId,
    };
  }
}