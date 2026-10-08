class SavingsGoal {
  const SavingsGoal({
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
  });

  final String name;
  final double targetAmount;
  final double savedAmount;

  double get progress =>
      (savedAmount / targetAmount).clamp(0.0, 1.0).toDouble();
  double get remaining =>
      (targetAmount - savedAmount).clamp(0.0, targetAmount).toDouble();

  SavingsGoal copyWith({
    String? name,
    double? targetAmount,
    double? savedAmount,
  }) {
    return SavingsGoal(
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
    );
  }

  Map<String, Object> toJson() => {
    'name': name,
    'targetAmount': targetAmount,
    'savedAmount': savedAmount,
  };

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final targetAmount = json['targetAmount'];
    final savedAmount = json['savedAmount'];
    if (name is! String ||
        name.trim().isEmpty ||
        targetAmount is! num ||
        targetAmount <= 0 ||
        savedAmount is! num ||
        savedAmount < 0) {
      throw const FormatException('Saved savings goal is invalid.');
    }
    return SavingsGoal(
      name: name,
      targetAmount: targetAmount.toDouble(),
      savedAmount: savedAmount.toDouble(),
    );
  }
}
