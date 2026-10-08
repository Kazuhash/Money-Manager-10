import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/savings_goal.dart';
import '../provider/savings_goal_provider.dart';
import 'app_setting.dart';
import 'app_theme.dart';

class SavingsGoalPage extends StatelessWidget {
  const SavingsGoalPage({super.key});

  Future<void> _editGoal(
    BuildContext context, {
    SavingsGoal? current,
  }) async {
    final nameController = TextEditingController(text: current?.name ?? '');
    final targetController = TextEditingController(
      text: current?.targetAmount.toStringAsFixed(0) ?? '',
    );
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<(String, double)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(current == null ? 'Buat target tabungan' : 'Edit target'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                autofocus: true,
                maxLength: 40,
                decoration: const InputDecoration(
                  labelText: 'Nama target',
                  hintText: 'Contoh: Dana darurat',
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                    ? 'Nama target wajib diisi'
                    : null,
              ),
              TextFormField(
                controller: targetController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Jumlah target',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final amount = double.tryParse(value?.trim() ?? '');
                  return amount == null || !amount.isFinite || amount <= 0
                      ? 'Masukkan jumlah lebih dari 0'
                      : null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(
                dialogContext,
                (nameController.text.trim(), double.parse(targetController.text.trim())),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    nameController.dispose();
    targetController.dispose();
    if (result == null || !context.mounted) return;

    try {
      await context.read<SavingsGoalProvider>().saveGoal(
        name: result.$1,
        targetAmount: result.$2,
      );
    } catch (error) {
      if (context.mounted) _showError(context, error);
    }
  }

  Future<void> _addContribution(BuildContext context) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tambah tabungan'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Jumlah yang ditabung',
              prefixText: 'Rp ',
            ),
            validator: (value) {
              final parsed = double.tryParse(value?.trim() ?? '');
              return parsed == null || !parsed.isFinite || parsed <= 0
                  ? 'Masukkan jumlah lebih dari 0'
                  : null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(dialogContext, double.parse(controller.text.trim()));
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount == null || !context.mounted) return;

    try {
      await context.read<SavingsGoalProvider>().addContribution(amount);
    } catch (error) {
      if (context.mounted) _showError(context, error);
    }
  }

  void _showError(BuildContext context, Object error) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
  }

  @override
  Widget build(BuildContext context) {
    final goal = context.watch<SavingsGoalProvider>().goal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Tabungan'),
        centerTitle: true,
        flexibleSpace: const HologramGradientBackground(
          lightModeGradient: AppTheme.hologramGradient,
        ),
      ),
      body: SafeArea(
        child: goal == null
            ? _EmptyGoal(onCreate: () => _editGoal(context))
            : _GoalDetails(
                goal: goal,
                onAdd: () => _addContribution(context),
                onEdit: () => _editGoal(context, current: goal),
              ),
      ),
    );
  }
}

class _EmptyGoal extends StatelessWidget {
  const _EmptyGoal({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Buat target tabungan pertama',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih tujuan dan jumlah target untuk mulai melacak kemajuanmu.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Buat target'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalDetails extends StatelessWidget {
  const _GoalDetails({
    required this.goal,
    required this.onAdd,
    required this.onEdit,
  });

  final SavingsGoal goal;
  final VoidCallback onAdd;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final percent = (goal.progress * 100).round();
    final completed = goal.savedAmount >= goal.targetAmount;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit target',
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  settings.formatMoney(goal.savedAmount),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text('dari ${settings.formatMoney(goal.targetAmount)}'),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    minHeight: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$percent% tercapai'),
                    Text(
                      completed
                          ? 'Target tercapai!'
                          : 'Sisa ${settings.formatMoney(goal.remaining)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: completed ? null : onAdd,
          icon: const Icon(Icons.add),
          label: Text(completed ? 'Target tercapai' : 'Tambah tabungan'),
        ),
      ],
    );
  }
}
